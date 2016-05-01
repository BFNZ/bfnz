require 'rails_helper'

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
    subject(:created_between_scope) {
      Order.created_between(Date.parse('2014-1-1'), Date.parse('2014-1-31'))
    }

    let!(:dec31) do
      Timecop.freeze(Time.new(2013,12,31,1,0,0)) { Order.make! }
    end
    let!(:jan1) do
      Timecop.freeze(Time.new(2014,1,1,1,0,0)) { Order.make! }
    end
    let!(:jan31) do
      Timecop.freeze(Time.new(2014,1,31,1,0,0)) { Order.make! }
    end
    let!(:feb1) do
      Timecop.freeze(Time.new(2014,2,1,1,0,0)) { Order.make! }
    end

    it "returns order that were created on or in between the dates specified" do
      expect(created_between_scope).to match_array [jan1, jan31]
    end
  end

  describe ".shipped_between" do
    subject(:shipped_between_scope) {
      Order.shipped_between(Date.new(2014,1,1), Date.new(2014,1,31))
    }

    let!(:dec31) do
      Timecop.freeze(Time.new(2013,12,31,1,0,0)) { Order.make!(:shipped) }
    end
    let!(:jan1) do
      Timecop.freeze(Time.new(2014,1,1,11,0,0)) { Order.make!(:shipped) }
    end
    let!(:jan31) do
      Timecop.freeze(Time.new(2014,1,31,12,0,0)) { Order.make!(:shipped) }
    end
    let!(:feb1) do
      Timecop.freeze(Time.new(2014,2,1,1,0,0)) { Order.make!(:shipped) }
    end

    it "returns order that were shipped on or in between the dates specified" do
      expect(shipped_between_scope).to match_array [jan1, jan31]
    end
  end

  describe ".item_ids" do
    subject(:item_ids_scope) { Order.item_ids([new_testament.id]) }

    let(:new_testament)   { Item.find_by_code('R') }
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

    it "returns orders that are shipped" do
      expect(shipped_scope).to match_array [shipped_order]
    end
  end

  describe ".ready_to_ship" do
    subject(:ready_to_ship_scope) { Order.ready_to_ship }

    let!(:shipped_order) { Order.make!(shipment: Shipment.new) }
    let!(:not_shipped_order) { Order.make! }

    it "returns orders that are not shipped" do
      expect(ready_to_ship_scope).to eq [not_shipped_order]
    end
  end
end
