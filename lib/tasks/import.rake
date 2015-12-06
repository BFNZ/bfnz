require 'spreadsheet'
namespace :import do

  desc "Import data from ASP version of Bibles for NZ"
  task customers: :environment do
    filename = File.join Rails.root, "import.xls"

    Spreadsheet.client_encoding = "UTF-8"

    book = Spreadsheet.open filename

    customers = book.worksheet "subscribers"

    counter = 0

    customers.each do |row|
      id, old_id, place_id, first_name, last_name, address, suburb, city_town, phone, email, tertiary_student, institution, gender, admin_notes, how_heard_id, method_received_id, date_entered, further_contact_id, coordinator_notes, reading_group_requested, shipped_before_entry, date_coordinator_notified, temp_date_followup_sent = row

      customer = Customer.create(first_name: first_name, last_name: last_name, address: address, suburb: suburb, city_town: city_town, phone: phone, email: email, tertiary_student: tertiary_student, tertiary_institution: institution)
      puts "#{id} - #{customer.errors.full_messages.join(",")}" if customer.errors.any?
      counter += 1 if customer.persisted?
    end
      
    puts "Imported #{counter} customers"
  end

end
