require 'rails_helper'

describe Shipment do
  describe ".create_for_orders" do
    subject(:create_for_orders) { Shipment.create_for_orders(orders) }

    let(:orders) { Order.all }

    before do
      Order.make!
      Order.make!
    end

    it "returns a new shipment" do
      expect(create_for_orders).to be_a Shipment
    end

    it "updates all of the orders with the new shipment id" do
      shipment = create_for_orders
      orders.each do |order|
        expect(order.shipment_id).to eq shipment.id
      end
    end
  end
end
