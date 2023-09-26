json.order do
  json.id order.id

  json.customer order.customer, partial: 'api/v1/customer', as: :customer
  json.items order.items, partial: 'api/v1/item', as: :item
  json.shipment order.shipment, partial: 'api/v1/shipment', as: :shipment

  json.success true
  json.created_at order.created_at
end
