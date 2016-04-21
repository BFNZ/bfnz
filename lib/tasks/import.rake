require 'spreadsheet'
require 'tiny_tds'
require 'csv'

#Export addresses from legacy SQL Server database as a CSV file to be manually cleansed with AddressFinder batch service

#usage: $ rake export_from_SQL_SERVER[sql-server-ip-address, path-to-cleansed-address-file]

task :export_from_SQL_SERVER, [:ip] do |t, args|
  
  client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  result = client.execute("select * from subscribers")
  counter = 0
  puts CSV.generate_line(["id", "first_name", "last_name", "address"])
  result.each do |r|
    post_code = ''
    city_town = ''
    if r['city_town']
      post_code = r['city_town'].match(/\d{4}$/)
      city_town = r['city_town'].gsub(/ \d{4}$/, '')
    end
    address = (r['address'] ? r['address'] : '') + ', ' + (r['suburb'] ? r['suburb'] : '') + ', ' + city_town
    
    address.gsub!(/(, ){2,}/, ', ')
    address.gsub!(/, $/, '')
    
    puts CSV.generate_line([r['id'], r['first_name'], r['last_name'], address])
    counter += 1
    break if counter > 10
  end
  

#  puts args[:path_to_cleansed_addresses]

  
#  puts "#{args[:ip]}  #{args[:path_to_cleansed_addresses]}"
end

  
# Import data from ASP version of Bibles for NZ
  
# run with : rake import[sql-server-ip-address]
  
task :import, [:ip] do |t, args|
  # copy code in here when it works
end    
  
task :temp, [:ip, :path_to_cleansed_addresses] => :environment do |t, args|

  territorial_authorities = {}
  TerritorialAuthority.find_each do |ta|
    territorial_authorities[ta.name] = ta.id
  end

#  territorial_authorities.keys.each do |ta|
#    puts "#{territorial_authorities[ta]} - #{ta}"
#  end
  
  addresses = {}
  CSV.foreach(args[:path_to_cleansed_addresses], :headers => true) do |r|
    addresses[r['id'].to_i] = {
      full_address: r['full address'],
      suburb: r['suburb'],
      city: r['city'],
      postcode: r['postcode'],
      ta: r['territorial authority'],
      pxid: r['pxid']
    }
  end

  #    puts addresses[44586]

  client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
  result = client.execute("select * from subscribers where id in (44586,11452,26895,26845,46245,30628)")
  
  Customer.delete_all()
  counter = 0
  result.each do |r|


#    puts r
    
    old_id = r['id'].to_i
    address_info = addresses[old_id]

    ta_name = address_info[:ta]
    ta_id = nil
    if ta_name
      ta_id = territorial_authorities[ta_name]
    end

    postcode = nil
    if address_info[:postcode]
      postcode = address_info[:postcode]
    elsif r['city_town'].match(/\d{4}$/)
      postcode = r['city_town'].match(/\d{4}$/)[0]
    end

    city_town = nil
    if address_info[:city]
      city_town = address_info[:city]
    else
      city_town =  r['city_town'].gsub(/ \d{4}$/, '')
    end

    title = nil
    
    if r['gender'] == 'Male'
      title = 'Mr'
    elsif  r['gender'] == 'Female'
      title = 'Ms'
    end

    customer = Customer.create(
      territorial_authority_id: ta_id,
      first_name: r['first_name'],
      last_name: r['last_name'],
      address: address_info[:full_address],
      suburb: address_info[:suburb],
      city_town: city_town,
      post_code: postcode,
      ta: address_info[:ta],
      pxid: address_info[:pxid],
      phone: r['phone'],
      email: r['email'],
      title: title,
      tertiary_student: r['tertiary_student'],
      tertiary_institution: r['institution'],
      admin_notes: r['admin_notes'],
      coordinator_notes: r['coordinator_notes'],
      old_subscriber_id: r['id'],
      old_system_address: r['address'],
      old_system_suburb: r['suburb'],
      old_system_city_town: r['city_town']
    )
    puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
    counter += 1 if customer.persisted?
#    break if counter > 10
  end


  #TODO: need to create orders for each

  
  puts "Imported #{counter} customers"
    
end

