require 'spreadsheet'
namespace :import do

  desc "Import data from ASP version of Bibles for NZ"
  task customers: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    customers = book.worksheet "subscribers"

    counter = 0

    customers.each 1 do |row|
      id, old_id, place_id, first_name, last_name, address, suburb, city_town, phone, email, tertiary_student, institution, gender, admin_notes, how_heard_id, method_received_id, date_entered, further_contact_id, coordinator_notes, reading_group_requested, shipped_before_entry, date_coordinator_notified, temp_date_followup_sent = row

      customer = Customer.create(first_name: first_name, last_name: last_name, address: address, suburb: suburb, city_town: city_town, phone: phone, email: email, tertiary_student: tertiary_student, tertiary_institution: institution, admin_notes: admin_notes, coordinator_notes: coordinator_notes, old_subscriber_id: id)
      puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
      counter += 1 if customer.persisted?
    end
      
    puts "Imported #{counter} customers"
  end


     task orders: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    orders = book.worksheet "shipments"

    counter = 0

    orders.each 1 do |row|
      id,date_shipped, item_id, subscriber_id = row

      order = Order.create(shipment_id: id, customer_id: subscriber_id)
      puts "#{id} - #{order.errors.full_messages.join(",")}" if order.errors.any?
      counter += 1 if order.persisted?
    end
      
    puts "Imported #{counter} orders"
  end


       task items_orders: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    items_orders = book.worksheet "requests"

    counter = 0

    items_orders.each 1 do |row|
      id, date_requested, item_id, subscriber_id, subscriber_feedback = row

      items_order = Items_order.create(item_id: item_id, order_id: id)
      puts "#{id} - #{items_order.errors.full_messages.join(",")}" if items_order.errors.any?
      counter += 1 if items_order.persisted?
    end
      
    puts "Imported #{counter} items_orders"
  end

   task items: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    items = book.worksheet "items"

    counter = 0

   items.each 1 do |row|
      id, name, request_required, ship_order, days_to_delay = row

      item = Item.create(title: name, code: id)
      puts "#{id} - #{item.errors.full_messages.join(",")}" if item.errors.any?
      counter += 1 if item.persisted?
    end
      
    puts "Imported #{counter} items"
  end
end
