desc "Link Orders with Territorial Authorities"
task :link_orders_with_ta => :environment do
  order_count = 0

  orders = Order.where('ta is not null').where(territorial_authority_id: nil)
  if orders.count == 0
    puts "All orders have a TA, exiting.."
    exit
  else
    puts "Found #{orders.count} orders that don't have a TA, linking.."
  end

  orders.each do |order|
    if ta = TerritorialAuthority.find_by_addressfinder_name(order.ta)
      order.update_column(:territorial_authority_id, ta.id)
      order_count +=1
    end
  end

  puts "Updated #{order_count} orders"
end
