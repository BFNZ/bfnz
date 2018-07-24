require 'spreadsheet'
require 'csv'

# Find duplicates for customer details for orders that have not yet been shipped.
# This needs to be run before the regular shipping days in order to allow users to look at the
# Export to CSV file.  (Future enhancement may include setting duplicate flag and adding admin note with link to duplicates.)
#  usage: $ rake find_duplicates_unshipped_> output-file.csv
task :find_duplicates_unshipped => :environment do |t, args|
  start = Time.now
  duplicates_found_counter = 0
  p "Start Time: #{start}"
  dup_filename = "dup_" + Time.now.strftime('%Y-%m-%d_%H-%M-%S')

  csv = CSV.open("/tmp/#{dup_filename}", 'a+') do |row|
      row << ["master_id","duplicate_type","customer_id","title","first_name","last_name",
              "address","email","phone","ip_address","cust_create_date","admin_notes",
              "order_id","order_items","order_date","ship_date","created_by"]
  end

  #find all the customers that have an unshipped order.
  #the statement below is still returning all Customer records - I only want the records not shipped.
  unshipped_customers = Order.select(:customer_id).where("shipment_id is null and customer_id not in (select id from customers where bad_address = true)")

  p "Number of Unshipped Orders #{unshipped_customers.size}"

  unshipped_customers.each do |unshipped|
    puts '\n'
    p '-------New Customer --------------------'
    print unshipped.customer_id
    u_cust_id = unshipped.customer_id
    duplicate_found = false

    master_customer = Customer.find_by_id(u_cust_id)

    if master_customer.pxid.blank?
      duplicate_found = true
    else
      address_duplicates = find_address_duplicates(master_customer)
      if address_duplicates && address_duplicates.size > 0
        duplicate_found = true
      end
    end

    full_name_duplicates = find_full_name_duplicates(master_customer)
    if full_name_duplicates && full_name_duplicates.size > 0
      duplicate_found = true
    end

    phone_duplicates = find_phone_duplicates(master_customer)
    if phone_duplicates && phone_duplicates.size > 0
      duplicate_found = true
    end

    email_duplicates = find_email_duplicates(master_customer)
    if email_duplicates && email_duplicates.size > 0
      duplicate_found = true
    end

    ip_address_duplicates = find_ip_address_duplicates(master_customer)
    if ip_address_duplicates && ip_address_duplicates.size > 0
      duplicate_found = true
    end

    if duplicate_found == true
      duplicates_found_counter += 1
      dup_print_line_header(master_customer.id, dup_filename)
      if address_duplicates && address_duplicates.size > 0
        dup_print_line('address',address_duplicates, master_customer.id, dup_filename  )
      end
      if full_name_duplicates && full_name_duplicates.size > 0
        dup_print_line('full_name',full_name_duplicates, master_customer.id, dup_filename  )
      end
      puts "after full name print_line"
      if phone_duplicates && phone_duplicates.size > 0
        puts "b4 print_line phone"
        dup_print_line('phone',phone_duplicates, master_customer.id, dup_filename  )
      end
      if email_duplicates && email_duplicates.size > 0
        dup_print_line('email',email_duplicates, master_customer.id, dup_filename  )
      end
      if ip_address_duplicates && ip_address_duplicates.size > 0
        dup_print_line('ip_address',ip_address_duplicates, master_customer.id, dup_filename )
      end
      puts "Finished Customer: #{master_customer.id}"
    end
  end


  puts "\n ----------------------------------------------"
  puts " #{duplicates_found_counter} unshipped duplicates added"
  finish = Time.now
  puts "Took: #{((finish - start)/60).round(2)}  minutes"
  p "End Time #{finish}"
end
# for all the customers with unshipped orders check for duplicate full name
def find_full_name_duplicates(master_customer)

  if master_customer.last_name != nil && master_customer.first_name != nil

 p "#{master_customer.first_name.downcase.gsub(/'/,"''")}"

    if master_customer.last_name.include?("'") || master_customer.first_name.include?("'")
      p "Found Quote in Name"
      p "First name #{master_customer.first_name.downcase.gsub(/'/,"''")}"
      p "Last name: #{master_customer.last_name.downcase.gsub(/'/,"''")}"
      duplicate_by_name = Customer.select(:id).where("lower(first_name) = '#{master_customer.first_name.downcase.gsub(/'/,"''")}'
                                                  and lower(last_name) = '#{master_customer.last_name.downcase.gsub(/'/,"''")}'
                                                  and id < #{master_customer.id}")

    else
      duplicate_by_name = Customer.select(:id).where("lower(first_name) = '#{master_customer.first_name.downcase}'
                                                  and lower(last_name) = '#{master_customer.last_name.downcase}'
                                                  and id < #{master_customer.id}")
    end
  end
end

# for all the customers with unshipped orders check for duplicate address
def find_address_duplicates(master_customer)
  if master_customer.pxid != nil
    duplicate_by_address = Customer.select(:id).where("pxid = '#{master_customer.pxid}'
                                                       and id < #{master_customer.id}")
  end
end

# for all the customers with unshipped orders check for duplicate phone number
def find_phone_duplicates(master_customer)
  if master_customer.phone != nil
    #TODO ignore customer records with no orders - i.e. merged records.
    duplicate_by_phone = Customer.select(:id).where("phone = '#{master_customer.phone}'
                                                       and id < #{master_customer.id}")
  end
end

# for all the customers with unshipped orders check for duplicate Email
def find_email_duplicates(master_customer)
  if master_customer.email != nil
    #TODO ignore customer records with no orders - i.e. merged records.
    duplicate_by_email = Customer.select(:id).where("email = '#{master_customer.email}'
                                                       and id < #{master_customer.id}")
  end
end

# for all the customers with unshipped orders check for ip address_info
def find_ip_address_duplicates(master_customer)
  # Lookup latest order for customers
  latest_customer_order_id = Order.select(:id).where("customer_id = #{master_customer.id}").maximum(:id)
  master_order = Order.find(latest_customer_order_id)
  if !master_order.ip_address.blank?
    duplicate_by_ip_address = Order.select(:id).where("Ip_Address = '#{master_order.ip_address}'
                                                    and id < #{master_order.id}")
  end
end

def dup_print_line_header (customer_id,dup_filename)
  customer = Customer.find_by_id(customer_id)
  order = Order.find_by(customer_id: customer_id, shipment_id: nil)
  item_codes = order.items.map(&:code).join
  p item_codes
  p order.created_by_id

  user = User.find_by_id(order.created_by_id)
  if user.blank?
    user_name = ''
  else
    user_name = user.name
  end

  master_id = customer.id
  duplicate_type = "Master"

  csv = CSV.open("/tmp/#{dup_filename}", 'a+') do |row|
      row <<  [master_id,duplicate_type,master_id,customer.title, customer.first_name,customer.last_name,
                   customer.address,customer.email,customer.phone.to_s,order.ip_address,customer.created_at,
                   customer.admin_notes, order.id, item_codes,order.created_at,'',user_name]
  end
  if customer.pxid.blank?
      duplicate_type = "Address not matched"

      csv = CSV.open("/tmp/#{dup_filename}", 'a+') do |row|
        row <<  ["-- " + master_id.to_s,duplicate_type,master_id,customer.title, customer.first_name,customer.last_name,
                     customer.address,customer.email,customer.phone.to_s,order.ip_address,customer.created_at,
                     customer.admin_notes, order.id, item_codes,order.created_at,'',user_name]
      end
  end
end

def dup_print_line ( type, duplicates, master_customer_id, dup_filename )
  case type
  when "ip_address"
    duplicates.each do |duplicate|
      # ip_address references an order record rather than customer
      puts "before order with dup_id #{duplicate.id}"
      order = Order.find_by_id(duplicate.id)
      puts "after order with dup_id #{duplicate.id}"
      puts "before dup_cust_id with dup_id #{order.customer_id}"
      dup_cust_id = order.customer_id
      export_line_to_csv(type, dup_cust_id, order.id, master_customer_id, dup_filename)
    end
  when "address"
    duplicates.each do |duplicate|
        order = Order.where("customer_id = '#{duplicate.id}'").select(:id).first
        if !order.blank?
          order_id = order.id
        else
          order_id = ""
        end
        export_line_to_csv(type, duplicate.id, order_id, master_customer_id, dup_filename)
    end
  when "full_name"
    p "full_name"
    duplicates.each do |duplicate|
      order = Order.where("customer_id = '#{duplicate.id}'").select(:id).first
      if !order.blank?
        order_id = order.id
      else
        order_id = ""
      end
      export_line_to_csv(type, duplicate.id, order_id, master_customer_id, dup_filename)
      puts "full_name finished"
      puts "full name size #{duplicates.size}"
    end
  when "phone"
    p "phone"
    duplicates.each do |duplicate|
      order = Order.where("customer_id = '#{duplicate.id}'").select(:id).first
      if !order.blank?
        order_id = order.id
      else
        order_id = ""
      end
      export_line_to_csv(type, duplicate.id, order_id, master_customer_id, dup_filename)
    end
  when "email"
    p "email"
    duplicates.each do |duplicate|
      order = Order.where("customer_id = '#{duplicate.id}'").select(:id).first
      if !order.blank?
        order_id = order.id
      else
        order_id = ""
      end
      export_line_to_csv(type, duplicate.id, order_id, master_customer_id, dup_filename)
    end
  else
    print "Error - no duplicate type found?"
  end
end

def export_line_to_csv(type, duplicate_id, order_id, master_customer_id, dup_filename)
  customer = Customer.find_by_id(duplicate_id)
  if !order_id.blank?
    order = Order.find_by_id(order_id)
    item_codes = order.items.map(&:code).join
    user = User.find_by_id(order.created_by_id)
    if user.blank?
      user_name = ''
    else
      user_name = user.name
    end
    order_ip_address = order.ip_address
    order_id = order.id
    order_created_at = order.created_at
  else
    order_ip_address = ""
    order_id = ""
    item_codes = ""
    order_created_at = ""
  end
  csv = CSV.open("/tmp/#{dup_filename}", 'a+') do |row|
    row <<  ["--" + master_customer_id.to_s ,type,customer.id,customer.title, customer.first_name,customer.last_name,
                 customer.address,customer.email,customer.phone.to_s,order_ip_address,customer.created_at,
                 customer.admin_notes, order_id, item_codes,order_created_at,'',user_name]
  end
  puts "type #{type}"
  p "After CSV"
end
