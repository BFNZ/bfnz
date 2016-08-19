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

desc "Add an admin user"
task :add_admin_user => :environment do

user_name = ENV["USER_NAME"]
user_email = ENV["USER_EMAIL"]
user_password = ENV["USER_PASSWORD"]
   
User.create!(name: user_name, email: user_email, password: user_password, password_confirmation: user_password, admin: true) unless User.find_by_email(user_email)
 
end

