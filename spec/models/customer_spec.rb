require 'rails_helper'

describe Customer do
  describe ".customer_id" do
    subject(:customer_id_scope) { Customer.customer_id(match.id) }

    let!(:match) { Customer.make! }
    let!(:nope)  { Customer.make! }

    it "returns customers that match on customer id" do
      expect(customer_id_scope).to match_array [match]
    end
  end

  describe ".first_name" do
    subject(:first_name_scope) { Customer.first_name("den") }

    let!(:dennis) { Customer.make!(first_name: 'Dennis') }
    let!(:ayden)  { Customer.make!(first_name: 'Ayden') }
    let!(:dean)   { Customer.make!(first_name: 'Dean') }

    it "returns customers that match on first name" do
      expect(first_name_scope).to match_array [dennis, ayden]
    end
  end

  describe ".last_name" do
    subject(:last_name_scope) { Customer.last_name("den") }

    let!(:dennis) { Customer.make!(last_name: 'Dennis') }
    let!(:ayden)  { Customer.make!(last_name: 'Ayden') }
    let!(:dean)   { Customer.make!(last_name: 'Dean') }

    it "returns customers that match on last name" do
      expect(last_name_scope).to match_array [dennis, ayden]
    end
  end

  describe ".email" do
    subject(:email_scope) { Customer.email("user@abc") }

    let!(:upcase)     { Customer.make!(email: 'USER@abc.def') }
    let!(:like_match) { Customer.make!(email: 'newuser@abc.com') }
    let!(:no_match)   { Customer.make!(email: 'user@gmail.com') }

    it "returns customers that fuzzy match on email" do
      expect(email_scope).to match_array [upcase, like_match]
    end
  end

  describe ".phone" do
    subject(:phone_scope) { Customer.phone("855 970") }

    let!(:match1) { Customer.make!(phone: '(07) 855 9709') }
    let!(:match2) { Customer.make!(phone: '(04) 8559 705') }
    let!(:nope)   { Customer.make!(phone: '(04) 986 5970') }

    it "returns customers that match on the specific phone numbers" do
      expect(phone_scope).to match_array [match1, match2]
    end
  end

  describe ".address" do
    subject(:address_scope) { Customer.address("Flower St") }

    let!(:match1) { Customer.make!(address: '4 Flower Street') }
    let!(:match2) { Customer.make!(address: '6 Flower st') }
    let!(:nope)   { Customer.make!(address: '7 Flowerbed St') }

    it "returns customers that match on last name" do
      expect(address_scope).to match_array [match1, match2]
    end
  end

  describe ".suburb" do
    subject(:suburb_scope) { Customer.suburb("town") }

    let!(:match1) { Customer.make!(suburb: 'Townville') }
    let!(:match2) { Customer.make!(suburb: 'Sunnytown') }
    let!(:nope)   { Customer.make!(suburb: 'Hamilton') }

    it "returns customers that match on suburb" do
      expect(suburb_scope).to match_array [match1, match2]
    end
  end

  describe ".city_town" do
    subject(:city_town_scope) { Customer.city_town("town") }

    let!(:match1) { Customer.make!(city_town: 'Townville') }
    let!(:match2) { Customer.make!(city_town: 'Sunnytown') }
    let!(:nope)   { Customer.make!(city_town: 'Hamilton') }

    it "returns customers that match on city_town" do
      expect(city_town_scope).to match_array [match1, match2]
    end
  end

  describe '#ta=' do
    subject(:customer) { Customer.new }

    let(:hamilton) { TerritorialAuthority.find_by_code("016") }
    let(:ta) { hamilton.name }

    before do
      customer.ta = ta
    end

    it 'sets the ta field' do
      expect(customer.ta).to eq 'Hamilton City'
    end

    it "sets the TerritorialAuthority association" do
      expect(customer.territorial_authority).to eq hamilton
    end
  end
end
