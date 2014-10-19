require 'machinist/active_record'

Order.blueprint do
  first_name { "Charlie" }
  last_name  { "Brown" }
  title      { "Mr" }
  address    { "Hennepin County, Minnesota" }
  items      { [Item.first] }
end

Order.blueprint(:shipped) do
  shipment { Shipment.create }
end

## Items are loaded from seed data

## TerritorialAuthorities are loaded from seed data
