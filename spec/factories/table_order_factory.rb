FactoryGirl.define do
  factory :table_order, class: Order do
    table
    shipment Shipment.new
  end
end