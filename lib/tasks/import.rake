# coding: utf-8
require 'spreadsheet'
require 'csv'

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
      if address_info[:postcode] != nil
        postcode = address_info[:postcode]
      elsif customer.old_system_city_town && customer.old_system_city_town.match(/\d{4}$/)
        postcode = customer.old_system_city_town.match(/\d{4}$/)[0]
      end
      city_town = nil
      if address_info[:city]
        city_town = address_info[:city]
      elsif customer.old_system_city_town
        city_town =  customer.old_system_city_town.gsub(/ \d{4}$/, '')
      end
      customer.territorial_authority_id = ta_id
      customer.address = address_info[:full_address]
      customer.suburb = address_info[:suburb]
      customer.city_town = city_town
      customer.post_code = postcode
      customer.ta = address_info[:ta]
      customer.pxid = address_info[:pxid]
      customer.dpid = address_info[:dpid]
      customer.x = address_info[:x]
      customer.y = address_info[:y]
      if customer.save
      else
        p customer.errors.messages
      end
      add_counter += 1
    end
  end
  puts "#{add_counter} address info added"
  finish = Time.now
  puts "Took: #{((finish - start)/60).round(2)}  minutes"
end

def get_cleansed_addresses(path)
  addresses = {}
  CSV.foreach(path, :headers => true) do |r|
    addresses[r['id'].to_i] = {
      full_address: r['full_address'],
      suburb: r['suburb'],
      city: r['city'],
      postcode: r['postcode'],
      ta: r['ta'],
      pxid: r['pxid'],
      dpid: r['dpid'],
      x: r['x'],
      y: r['y']
    }
  end
  addresses
end

def int_to_date_time(int)
  DateTime.strptime(int.to_s, '%Y%m%d%H%M%S')
end

def get_territorial_authorities
  territorial_authorities = {}
  TerritorialAuthority.find_each do |ta|
    territorial_authorities[ta.name] = ta.id
  end
  territorial_authorities
end
