require 'rails_helper'

RSpec.describe Admin::CancelOrderService do
  let(:cancel_order) { described_class.new(order: order, user: user) }

  let(:customer) do
    Customer.create!(title: 'Mr', first_name: 'Joe',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let(:ordered_item) { Item.first }
  let(:order) { Order.create!(customer: customer, item_ids: [ordered_item.id]) }
  let(:user) { double(:admin, id: 55) }

  describe "#perform" do
    it "creates a cancelled order event" do
      cancel_order.perform
      expect(CancelledOrderEvent.last).
        to have_attributes(cancelled_by_id: user.id,
                           customer_id: customer.id,
                           order_details: hash_including(item_ids: [ordered_item.id]))
    end

    it "deletes the order" do
      cancel_order.perform
      expect(order).to be_destroyed
    end
  end
end
