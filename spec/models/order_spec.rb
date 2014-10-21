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

  describe ".email" do
    subject(:email_scope) { Order.email("user@abc") }

    let!(:upcase)     { Order.make!(email: 'USER@abc.def') }
    let!(:like_match) { Order.make!(email: 'newuser@abc.com') }
    let!(:no_match)   { Order.make!(email: 'user@gmail.com') }

    it "returns orders that fuzzy match on email" do
      expect(email_scope).to match_array [upcase, like_match]
    end
  end

  describe ".phone" do
    subject(:phone_scope) { Order.phone("855 970") }

    let!(:match1) { Order.make!(phone: '(07) 855 9709') }
    let!(:match2) { Order.make!(phone: '(04) 8559 705') }
    let!(:nope)   { Order.make!(phone: '(04) 986 5970') }

    it "returns orders that match on the specific phone numbers" do
      expect(phone_scope).to match_array [match1, match2]
    end
  end

  describe ".address" do
    subject(:address_scope) { Order.address("Flower St") }

    let!(:match1) { Order.make!(address: '4 Flower Street') }
    let!(:match2) { Order.make!(address: '6 Flower st') }
    let!(:nope)   { Order.make!(address: '7 Flowerbed St') }

    it "returns order that match on last name" do
      expect(address_scope).to match_array [match1, match2]
    end
  end

  describe ".suburb" do
    subject(:suburb_scope) { Order.suburb("town") }

    let!(:match1) { Order.make!(suburb: 'Townville') }
    let!(:match2) { Order.make!(suburb: 'Sunnytown') }
    let!(:nope)   { Order.make!(suburb: 'Hamilton') }

    it "returns order that match on suburb" do
      expect(suburb_scope).to match_array [match1, match2]
    end
  end

  describe ".city_town" do
    subject(:city_town_scope) { Order.city_town("town") }

    let!(:match1) { Order.make!(city_town: 'Townville') }
    let!(:match2) { Order.make!(city_town: 'Sunnytown') }
    let!(:nope)   { Order.make!(city_town: 'Hamilton') }

    it "returns order that match on city_town" do
      expect(city_town_scope).to match_array [match1, match2]
    end
  end

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

  describe ".ready_to_ship" do
    subject(:ready_to_ship_scope) { Order.ready_to_ship }

    let!(:shipped_order) { Order.make!(shipment: Shipment.new) }
    let!(:not_shipped_order) { Order.make! }

    it "returns orders that are not shipped" do
      expect(ready_to_ship_scope).to eq [not_shipped_order]
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
