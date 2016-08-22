# coding: utf-8
require 'spreadsheet'
require 'tiny_tds'
require 'csv'

# Export addresses from legacy SQL Server database as a CSV file to be manually cleansed with AddressFinder batch service
# Exclude any records in the provided CSV file
# usage: $ rake export_from_SQL_SERVER_with_existing[sql-server-ip-address,path-to-existing-cleansed-addresses] > output-file.csv
#  (note: no space between arguments on the command line)
task :export_from_SQL_SERVER_with_existing, [:ip, :path_to_existing_cleansed_addresses] do |t, args|
  existing_addresses = get_cleansed_addresses(args[:path_to_existing_cleansed_addresses])
  sql_client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  new_export_addresses = export_addresses(sql_client, existing_addresses)
  new_export_addresses.each do |address|
    puts CSV.generate_line(address)
  end
end

# Export addresses from legacy SQL Server database as a CSV file to be manually cleansed with AddressFinder batch service
#  usage: $ rake export_from_SQL_SERVER[sql-server-ip-address] > output-file.csv
task :export_from_SQL_SERVER, [:ip] do |t, args|
  sql_client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  new_export_addresses = export_addresses(sql_client, {})
  new_export_addresses.each do |address|
    puts CSV.generate_line(address)
  end
end

# Add address data to customers in the new system, passing a CSV that is the cleansed output from the AddressFinder batch service
#  usage: $ rake add_address_data[path-to-cleansed-address-csv-file]
task :add_address_data, [:path_to_cleansed_addresses] => :environment do |t, args|
  start = Time.now
  territorial_authorities = get_territorial_authorities
  addresses = get_cleansed_addresses(args[:path_to_cleansed_addresses])
  add_counter = 0
  Customer.find_each do |customer|
    if customer.old_subscriber_id
      address_info = addresses[customer.old_subscriber_id]
      ta_name = address_info[:ta]
      ta_id = nil
      if ta_name
        ta_id = territorial_authorities[ta_name]
      end

      postcode = nil
      if address_info[:postcode]
        postcode = address_info[:postcode]
      elsif customer.old_system_city_town.match(/\d{4}$/)
        postcode = customer.old_system_city_town.match(/\d{4}$/)[0]
      end

      city_town = nil
      if address_info[:city]
        city_town = address_info[:city]
      else
        city_town =  customer.old_system_city_town.gsub(/ \d{4}$/, '')
      end

      customer.territorial_authority_id = ta_id
      customer.address = address_info[:full_address]
      customer.suburb = address_info[:suburb]
      customer.city_town = city_town
      customer.post_code = postcode
      customer.ta = address_info[:ta]
      customer.pxid = address_info[:pxid]
      customer.save
      add_counter += 1
    end
  end
  puts "#{add_counter} address info added"
  finish = Time.now
  puts "Took: #{((finish - start)/60).round(2)}  minutes"
end

# Import data from old (ASP) system to new (Rails) system. Does not include cleansed address data
# run with : rake import[sql-server-ip-address]
task :import, [:ip] => :environment do |t, args|
  start = Time.now
  sql_client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]

  old_subscribers, old_subscribers_other_info = get_old_subscribers(sql_client)
  old_items = get_old_items(sql_client, get_new_items)
  old_requests = get_old_requests_by_subscriber(sql_client)
  old_shipments, unique_shipment_dates = get_old_shipments_by_subscriber_and_shipments(sql_client)
  old_how_heard = get_old_how_heard(sql_client, Order.method_of_discoveries)
  old_method_received = get_old_method_received(sql_client, Order.method_receiveds)
  old_further_contact, bad_address_id = get_old_further_contact_and_bad_address(sql_client, Customer.further_contact_requesteds)

  Shipment.delete_all()
  Order.find_each do |order|
    order.items.each do |item|
      order.items.delete(item)
    end
  end
  Order.delete_all()
  Customer.delete_all()

  ship_counter = 0
  unique_shipment_dates.keys.each do |date|
    shipment = Shipment.create()
    shipment.created_at = date
    shipment.save
    puts "ERROR: #{shipment.errors.full_messages.join(",")}" if shipment.errors.any?
    ship_counter += 1 if shipment.persisted?
    unique_shipment_dates[date] = shipment.id
  end
  puts "#{ship_counter} shipments created"

  sub_counter = 0
  old_subscribers.each do |sub_id, sub|
    customer = Customer.create(sub)
    sub[:new_id] = customer.id
    puts "ERROR: #{sub_id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
    sub_counter += 1 if customer.persisted?
  end
  puts "#{sub_counter} customers created"

  req_counter = 0
  ship_order_counter = 0
  old_requests.each do |sub_id, requests|
    if old_subscribers[sub_id]
      new_customer_id = old_subscribers[sub_id][:new_id]
      requests.each do |request|
        old_item_id = request[:item_id]
        new_item_id = old_items[old_item_id][:new_item_id]
        item = Item.find(new_item_id)
        request_date = request[:date_requested]

        method_of_discovery = old_how_heard[old_subscribers_other_info[sub_id][:how_heard_id]]
        method_received = old_method_received[old_subscribers_other_info[sub_id][:method_received_id]]

        customer = Customer.find(new_customer_id)

        if old_subscribers_other_info[sub_id][:further_contact_id] == bad_address_id
          customer.bad_address = true
          customer.save
        else
          further_contact = old_further_contact[old_subscribers_other_info[sub_id][:further_contact_id]]
          customer.further_contact_requested = further_contact
          customer.save
        end

        order = Order.create(
          method_of_discovery: method_of_discovery,
          created_at: request_date,
          method_received: method_received,
          customer_id: new_customer_id)
        request[:new_order_id] = order.id
        puts "ERROR: #{order.id} - #{order.errors.full_messages.join(",")}" if order.errors.any?
        order.items << item
        order.save
        req_counter += 1 if order.persisted?

        if old_shipments[sub_id] && old_shipments[sub_id].has_key?(old_item_id)
          date_shipped = old_shipments[sub_id][old_item_id]
          if unique_shipment_dates.has_key?(date_shipped)
            new_shipment_id = unique_shipment_dates[date_shipped]
            order.shipment_id = new_shipment_id
            order.save
            ship_order_counter += 1
          else
            puts "Error: shipment for date not found: #{date_shipped}"
          end
        end
      end
    end
  end
  puts "#{req_counter} orders created"
  puts "#{ship_order_counter} orders shipped"
  finish = Time.now
  puts "Took: #{((finish - start)/60).round(2)}  minutes"
end


def export_addresses(sql_client, existing_addresses)
  result = sql_client.execute("select * from subscribers")
  addresses = []
  addresses << ["id", "first_name", "last_name", "address"]
  result.each do |r|
    sub_id = r['id']
    if !existing_addresses.has_key?(sub_id)
      post_code = ''
      city_town = ''
      if r['city_town']
        post_code = r['city_town'].match(/\d{4}$/)
        city_town = r['city_town'].gsub(/ \d{4}$/, '')
      end
      address = (r['address'] ? r['address'] : '') + ', ' + (r['suburb'] ? r['suburb'] : '') + ', ' + city_town

      address.gsub!(/(, ){2,}/, ', ')
      address.gsub!(/, $/, '')
      addresses << [sub_id, r['first_name'], r['last_name'], address]
    end
  end
  addresses
end

def get_new_items
  items = {}
  Item.find_each do |item|
    items[item.code] = [item.id, item.title]
  end
  items
end

def get_territorial_authorities
  territorial_authorities = {}
  TerritorialAuthority.find_each do |ta|
    territorial_authorities[ta.name] = ta.id
  end
  territorial_authorities
end

def get_cleansed_addresses(path)
  addresses = {}
  CSV.foreach(path, :headers => true) do |r|
    addresses[r['id'].to_i] = {
      full_address: r['full address'],
      suburb: r['suburb'],
      city: r['city'],
      postcode: r['postcode'],
      ta: r['territorial authority'],
      pxid: r['pxid']
    }
  end
  addresses
end

def get_old_subscribers(sql_client)
#  result = sql_client.execute("select * from subscribers where id in (44586,11452,26895,26845,46245,30628)")
  result = sql_client.execute("select * from subscribers")

  old_subscribers = {}
  old_subscribers_other_info = {}

  result.each do |r|
    old_id = r['id'].to_i
    old_subscribers_other_info[old_id] = {how_heard_id: r['how_heard_id'], method_received_id: r['method_received_id'], further_contact_id: r['further_contact_id']}

    title = nil
    if r['gender'] == 'Male'
      title = 'Mr'
    elsif  r['gender'] == 'Female'
      title = 'Ms'
    end

    fields = Hash[[:phone, :email, :institution, :admin_notes, :coordinator_notes, :address, :suburb, :city_town].collect do |field_name|
                    value = nil
                    if r[field_name.to_s]
                      value = r[field_name.to_s].strip
                      value = nil if value.empty?
                    end
                    [field_name, value]
                  end
                 ]

    old_subscribers[old_id] = {
      first_name: r['first_name'],
      last_name: r['last_name'],
      phone: fields[:phone],
      email: fields[:email],
      title: title,
      tertiary_student: r['tertiary_student'],
      tertiary_institution: fields[:institution],
      admin_notes: fields[:admin_notes],
      coordinator_notes: fields[:coordinator_notes],
      old_subscriber_id: old_id,
      old_system_address: fields[:address],
      old_system_suburb: fields[:suburb],
      old_system_city_town: fields[:city_town],
      created_at: int_to_date_time(r['date_entered'])
    }
  end
  [old_subscribers, old_subscribers_other_info]
end

def get_old_items(sql_client, new_items)
  result = sql_client.execute("select * from items order by ship_order")
  old_items = {}
  result.each do |r|
    name = r['name']
    new_item_id = nil
    if name == 'Recovery Version'
      new_item_id = new_items['R'][0]
    elsif name == 'Basic Elements 1'
      new_item_id = new_items['X1'][0]
    elsif name == 'Basic Elements 2'
      new_item_id = new_items['X2'][0]
    elsif name == 'Basic Elements 3'
      new_item_id = new_items['X3'][0]
    end

    old_items[r['id'].to_i] = {name: r['name'], new_item_id: new_item_id}
  end
  old_items
end

def get_old_requests_by_subscriber(sql_client)
  result = sql_client.execute("select * from requests")
  old_requests = {}
  result.each do |r|
    sub_id = r['subscriber_id']
    request = {date_requested: int_to_date_time(r['date_requested']), item_id: r['item_id']}
    if old_requests.has_key?(sub_id)
      old_requests[sub_id] << request
    else
      old_requests[sub_id] = [request]
    end
  end
  old_requests
end

def get_old_shipments_by_subscriber_and_shipments(sql_client)
  result = sql_client.execute("select * from shipments")
  old_shipments_by_subscriber = {}
  unique_shipment_dates = {}
  result.each do |r|
    sub_id = r['subscriber_id']
    date_shipped = int_to_date_time(r['date_shipped'])
    item_id = r['item_id']
    shipment = {date_shipped: date_shipped, item_id: item_id}
    if old_shipments_by_subscriber.has_key?(sub_id)
      old_shipments_by_subscriber[sub_id][item_id] = date_shipped
    else
      old_shipments_by_subscriber[sub_id] = {item_id => date_shipped}
    end
    unique_shipment_dates[date_shipped] = 1
  end
  [old_shipments_by_subscriber, unique_shipment_dates]

end

# returns hash: {old how_heard_id => new method_discovered enum index}
def get_old_how_heard(sql_client, new_method_of_discoveries)
  result = sql_client.execute("select * from how_heard")
  old_how_heard = {}
  result.each do |r|
    case r['how_heard_short']
    when 'Unknown'
      old_how_heard[r['id']] = new_method_of_discoveries['unknown']
    when 'Mail'
      old_how_heard[r['id']] = new_method_of_discoveries['mail_disc']
    when 'Uni Lit'
      old_how_heard[r['id']] = new_method_of_discoveries['uni_lit']
    when 'Non-uni Lit'
      old_how_heard[r['id']] = new_method_of_discoveries['non_uni_lit']
    when 'Other Ad'
      old_how_heard[r['id']] = new_method_of_discoveries['other_ad']
    when 'Word of Mouth'
      old_how_heard[r['id']] = new_method_of_discoveries['word_of_mouth']
    when 'Internet'
      old_how_heard[r['id']] = new_method_of_discoveries['website']
    when 'Other'
      old_how_heard[r['id']] = new_method_of_discoveries['other_disc']
    end
  end
  old_how_heard
end

# returns hash: {old how_heard_id => new method_discovered enum index}
def get_old_method_received(sql_client, new_method_receiveds)
  result = sql_client.execute("select * from method_received")
  old_method_received = {}
  result.each do |r|
    case r['method_received']
    when 'Mail'
      old_method_received[r['id']] = new_method_receiveds['mail']
    when 'Phone'
      old_method_received[r['id']] = new_method_receiveds['phone']
    when 'Personally delivered'
      old_method_received[r['id']] = new_method_receiveds['personally_delivered']
    when 'Internet'
      old_method_received[r['id']] = new_method_receiveds['internet']
    when 'Other'
      old_method_received[r['id']] = new_method_receiveds['other']
    end
  end
  old_method_received
end

def get_old_further_contact_and_bad_address(sql_client, new_further_contact_requesteds)
  result = sql_client.execute("select * from further_contact")
  old_further_contact = {}
  bad_address = nil
  result.each do |r|
    case r['further_contact']
    when 'Not specified'
      old_further_contact[r['id']] = new_further_contact_requesteds['not_specified']
    when 'Wanted'
      old_further_contact[r['id']] = new_further_contact_requesteds['wanted']
    when 'Not wanted'
      old_further_contact[r['id']] = new_further_contact_requesteds['not_wanted']
    when 'Bad address'
      bad_address = r['id']
    end
  end
  [old_further_contact, bad_address]
end


def int_to_date_time(int)
  DateTime.strptime(int.to_s, '%Y%m%d%H%M%S')
end




# Compare data imported from old (ASP) system to new (Rails) system. Does not include cleansed address data
# run with : rake compare[sql-server-ip-address]
task :compare, [:ip] => :environment do |t, args|
  old_sql_client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  result = get_old_sub(31423, old_sql_client)
  result.each do |r|
    name = "#{r['first_name']} #{r['last_name']}"
    puts "#{r['id']}: #{name}"
  end

  new_cust = Customer.find_by old_subscriber_id: 31423

  puts "#{new_cust.id} [#{new_cust.old_subscriber_id}]: #{new_cust.first_name} #{new_cust.last_name}"

#  old_result = old_sql_client.execute("select * from subscribers")
#  old_result.each do |r|
#    name = "#{r['first_name']} #{r['last_name']}"
#    if /[^a-zA-Z\s\.\'\?\-\(\)\&\/\,]/.match(name)
#      puts "#{r['id']}: #{name}"
#    end
#    if r['id'] == 2504
#      puts "#{r['id']}: #{r['first_name']} #{r['last_name']}"
#    end
#  end



  # 2504: name contains ampersand: Hannah & Lydia Cho
  # 31423: name contains accents: Sione Tupou Taéíloa
  # 21435: name conatins special chars: Stephan Rößner

end

def get_old_sub(id, sql_client)
  sql_client.execute("select * from subscribers where id = #{id}")
end




# Find stuff (for working)
# run with : rake find[sql-server-ip-address]
task :find, [:ip] => :environment do |t, args|
  old_sql_client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  result = old_sql_client.execute(%q(
    SELECT TOP 10 subscribers.id, subscribers.first_name, subscribers.further_contact_id, further_contact.further_contact
    FROM subscribers
    LEFT JOIN further_contact ON subscribers.further_contact_id = further_contact.id
    WHERE further_contact.id = 4
))

  result.each do |r|
    puts r
  end
#  result.each do |r|
#    if /RD\s\d/.match(r['suburb'])
#      name = "#{r['first_name']} #{r['last_name']}"
#      puts "#{r['id']}: #{name}, #{r['address']} #{r['suburb']}"
#    end
#  end

#  new_cust = Customer.find_by old_subscriber_id: 31423

#  puts "#{new_cust.id} [#{new_cust.old_subscriber_id}]: #{new_cust.first_name} #{new_cust.last_name}"

#  old_result = old_sql_client.execute("select * from subscribers")
#  old_result.each do |r|
#    name = "#{r['first_name']} #{r['last_name']}"
#    if /[^a-zA-Z\s\.\'\?\-\(\)\&\/\,]/.match(name)
#      puts "#{r['id']}: #{name}"
#    end
#    if r['id'] == 2504
#      puts "#{r['id']}: #{r['first_name']} #{r['last_name']}"
#    end
#  end



  # 2504: name contains ampersand: Hannah & Lydia Cho
  # 31423: name contains accents: Sione Tupou Taéíloa
  # 21435: name conatins special chars: Stephan Rößner

end
