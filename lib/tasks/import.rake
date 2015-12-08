require 'spreadsheet'
namespace :import do

  desc "Import data from ASP version of Bibles for NZ"


  task customers: :environment do
        Customer.delete_all()
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    customers = book.worksheet "subscribers"

    counter = 0

    customers.each 1 do |row|
      id, old_id, place_id, first_name, last_name, address, suburb, city_town, phone, email, tertiary_student, institution, gender, admin_notes, how_heard_id, method_received_id, date_entered, further_contact_id, coordinator_notes, reading_group_requested, shipped_before_entry, date_coordinator_notified, temp_date_followup_sent = row

      customer = Customer.create(first_name: first_name, last_name: last_name, address: address, suburb: suburb, city_town: city_town, phone: phone, email: email, tertiary_student: tertiary_student, tertiary_institution: institution, admin_notes: admin_notes, coordinator_notes: coordinator_notes, old_subscriber_id: id, old_system_address: address, old_system_suburb: suburb, old_system_city_town: city_town)
      puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
      counter += 1 if customer.persisted?
    end
      
    puts "Imported #{counter} customers"
  end    

  task orders: :environment do
    Order.delete_all()
    Shipment.delete_all()
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    orders = book.worksheet "shipments"

    counter = 0

    orders.each 1 do |row|
      id,date_shipped, item_id, subscriber_id = row
      shipment = Shipment.create()
      shipment = Shipment.last
      customer= Customer.find_by_old_subscriber_id(id)
      olditem = item_id.to_s
      item= Item.find_by_code(olditem)
      order = Order.create(shipment_id: Shipment.id, customer_id: Customer.id)
      items_order = Items_order.create(item_id: Item.id, order_id: Order.id)
      puts "#{id} - #{order.errors.full_messages.join(",")}" if order.errors.any?
      counter += 1 if order.persisted?
    end
      
    puts "Imported #{counter} orders"
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
