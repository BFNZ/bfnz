require 'rails_helper'
require_relative 'shared_examples'

describe Order do
  describe ".id" do
    subject(:id_scope) { Order.id("6") }

    let!(:order6)  { Order.make!(id: 6)  }
    let!(:order66) { Order.make!(id: 66) }

    it "returns order that match on id" do
      expect(id_scope).to match_array [order6]
    end
  end

  describe ".created_between" do
    subject {
      Order.created_between(Date.parse('2014-1-1'), Date.parse('2014-1-31'))
    }
    include_examples 'date_range'
  end

  describe ".shipped_between" do
    subject(:shipped_between_scope) {
      Order.shipped_between(Date.new(2014,1,1), Date.new(2014,1,31))
    }
    include_examples 'date_range'
  end

  describe ".item_ids" do
    subject(:item_ids_scope) { Order.item_ids([new_testament.id]) }

    let(:new_testament) { Item.find_by_code('R') }
    let(:church) { Item.find_by_code('C') }

    let!(:nt_only)   { Order.make!(items: [new_testament]) }
    let!(:nt_and_church) { Order.make!(items: [new_testament, church]) }
    let!(:church_only)   { Order.make!(items: [church]) }

    it "returns orders that contain the items" do
      expect(item_ids_scope).to match_array [nt_only, nt_and_church]
    end
  end

  describe ".shipped" do
    subject(:shipped_scope) { Order.shipped }

    let!(:shipped_order) { Order.make!(shipment: Shipment.new) }
    let!(:not_shipped_order) { Order.make! }
    let!(:table_order) { FactoryGirl.create(:table_order) }

    it "returns orders that are shipped" do
      expect(shipped_scope).to match_array [shipped_order, table_order]
    end
  end

  describe ".ready_to_ship" do
    subject(:ready_to_ship_scope) { Order.ready_to_ship }

    let!(:shipped_order) { Order.make!(shipment: Shipment.new) }
    let!(:not_shipped_order) { Order.make!(customer: customer) }
    let!(:table_order) { FactoryGirl.create(:table_order) }
    let(:customer) { Customer.make! }

    it "returns orders that are not shipped" do
      expect(ready_to_ship_scope).to eq [not_shipped_order]
    end

    context "when the order is for a customer with a bad address" do
      let(:customer) { Customer.make!(bad_address: true) }

      it "doesn't include that order" do
        expect(ready_to_ship_scope).not_to include not_shipped_order
      end
    end

    context "when the order is for a customer who doesn't want to be contacted" do
      let(:customer) { Customer.make!(further_contact_requested: Customer.further_contact_requesteds[:not_wanted]) }

      it "doesn't include that order" do
        expect(ready_to_ship_scope).not_to include not_shipped_order
      end
    end
end
end
