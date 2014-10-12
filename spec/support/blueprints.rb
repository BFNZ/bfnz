require 'machinist/active_record'

Order.blueprint do
  first_name { "Charlie" }
  last_name  { "Brown" }
  title      { "Mr" }
  address    { "Hennepin County, Minnesota" }
  items      { [Item.first] }
end

## Items are loaded from seed data

## TerritorialAuthorities are loaded from seed data
