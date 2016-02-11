require 'spreadsheet'
require 'tiny_tds'
namespace :import do

  desc "Import data from ASP version of Bibles for NZ"

# run with : rake import:import[sql-server-ip-address]

 task :import, [:ip] do |t, args|
    #client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
    #result = client.execute("select * from districts")
    #result.each do |row|
     #puts row["name"]

    #end
  end    

task :temp, [:ip] => :environment do |t, args|
   client = TinyTds::Client.new username: "bfnz2", password: "bfnz", host: args[:ip]
    result = client.execute("select * from subscribers")
    Customer.delete_all()
    counter = 0
    result.each do |r|
      customer = Customer.create(first_name: r["first_name"], last_name: r["last_name"], address: r["address"], suburb: r["suburb"], city_town: r["city_town"], phone: r["phone"], email: r["email"], tertiary_student: r["tertiary_student"], tertiary_institution: r["institution"], admin_notes: r["admin_notes"], coordinator_notes: r["coordinator_notes"], old_subscriber_id: r["id"], old_system_address: r["address"], old_system_suburb: r["suburb"], old_system_city_town: r["city_town"])
      puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
      counter += 1 if customer.persisted?
      #break if counter > 10
    end
      
    puts "Imported #{counter} customers"


end

  task customers: :environment do
        Customer.delete_all()

    counter = 0

    customers.each 1 do |row|
      id, old_id, place_id, first_name, last_name, address, suburb, city_town, phone, email, tertiary_student, institution, gender, admin_notes, how_heard_id, method_received_id, date_entered, further_contact_id, coordinator_notes, reading_group_requested, shipped_before_entry, date_coordinator_notified, temp_date_followup_sent = row

      customer = Customer.create(first_name: first_name, last_name: last_name, address: address, suburb: suburb, city_town: city_town, phone: phone, email: email, tertiary_student: tertiary_student, tertiary_institution: institution, admin_notes: admin_notes, coordinator_notes: coordinator_notes, old_subscriber_id: id, old_system_address: address, old_system_suburb: suburb, old_system_city_town: city_town)
      puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
      counter += 1 if customer.persisted?
    end
      
    puts "Imported #{counter} customers"
  end    



   task items: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    items = book.worksheet "items"

    counter = 0
    date = 

   items.each 1 do |row|
      id, name, request_required, ship_order, days_to_delay, deactivated = row

      item = Item.create(title: name, code: id, deactivated_at: DateTime.now.beginning_of_day )
      puts "#{id} - #{item.errors.full_messages.join(",")}" if item.errors.any?
      counter += 1 if item.persisted?
    end
      
    puts "Imported #{counter} items"
  end
end
