require 'rails_helper'

describe Order do
  describe ".first_name" do
    subject(:first_name_scope) { Order.first_name("den") }

    let!(:dennis) { Order.make!(first_name: 'Dennis') }
    let!(:ayden)  { Order.make!(first_name: 'Ayden') }
    let!(:dean)   { Order.make!(first_name: 'Dean') }

    it "returns order that match on first name" do
      expect(first_name_scope).to match_array [dennis, ayden]
    end
  end

  describe ".last_name" do
    subject(:last_name_scope) { Order.last_name("den") }

    let!(:dennis) { Order.make!(last_name: 'Dennis') }
    let!(:ayden)  { Order.make!(last_name: 'Ayden') }
    let!(:dean)   { Order.make!(last_name: 'Dean') }

    it "returns order that match on last name" do
      expect(last_name_scope).to match_array [dennis, ayden]
    end
  end

  describe ".item_ids" do
    subject(:item_ids_scope) { Order.item_ids([new_testament.id]) }

    let(:new_testament)   { Item.find_by_code('R') }
    let(:glorious_church) { Item.find_by_code('G') }

    let!(:nt_only)   { Order.make!(items: [new_testament]) }
    let!(:nt_and_gc) { Order.make!(items: [new_testament, glorious_church]) }
    let!(:gc_only)   { Order.make!(items: [glorious_church]) }

    it "returns orders that contain the items" do
      expect(item_ids_scope).to match_array [nt_only, nt_and_gc]
    end
  end

  describe ".shipped" do
    subject(:shipped_scope) { Order.shipped(shipped) }

    let!(:shipped_order) { Order.make!(shipment: Shipment.new) }
    let!(:not_shipped_order) { Order.make! }

    context "when shipped is 1" do
      let(:shipped) { 1 }

      it "returns orders that are shipped" do
        expect(shipped_scope).to match_array [shipped_order]
      end
    end

    context "when shipped is 0" do
      let(:shipped) { 0 }

      it "returns orders that are not shipped" do
        expect(shipped_scope).to match_array [not_shipped_order]
      end
    end
  end

  describe '#ta=' do
    subject(:order) { Order.new }

    before do
      order.ta = ta
    end

    context "when it contains the word 'city'" do
      let(:ta) { 'hamilton city' }

      it 'strips city' do
        expect(order.ta).to eq 'hamilton'
      end
    end
  end
end
