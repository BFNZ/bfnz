require 'machinist/active_record'

Order.blueprint do
  customer
  items      { [Item.first] }
end

Customer.blueprint do
  first_name { "Charlie" }
  last_name  { "Brown" }
  title      { "Mr" }
  address    { "Hennepin County, Minnesota" }
end

Order.blueprint(:shipped) do
  shipment { Shipment.create }
end

User.blueprint do
  name                  { 'Simon Says' }
  email                 { "simon#{sn}@says.com" }
  password              { 'secret' }
  password_confirmation { 'secret' }
end

User.blueprint(:admin) do
  admin { true }
end

User.blueprint(:coordinator) do
  admin { false }
end

## Items are loaded from seed data

## TerritorialAuthorities are loaded from seed data
