require 'rails_helper'

RSpec.describe Admin::MergeCustomerService do
  let(:merge_customer) do
    described_class.new(user: user, form: form)
  end
  let(:form) { double(:form, original: original, duplicate: duplicate, valid?: true) }
  let(:original) do
    Customer.create!(title: 'Mr', first_name: 'Joe',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let(:duplicate) do
    Customer.create!(title: 'Mr', first_name: 'Joseph',
                     last_name: 'Smith', address: '123 Sesame Street',
                     city_town: 'Wellington', post_code: '1234',
                     ta: 'wellington')
  end
  let!(:order) do
    Order.create!(customer: duplicate, item_ids: [Item.first.id])
  end
  let(:user) { double(:admin, id: 55) }

  describe "#perform" do
    context "when not able to merge" do
      before do
        allow(form).to receive(:valid?).and_return(false)
      end

      it "is not successful" do
        expect(merge_customer.perform).not_to be_success
      end
    end

    context "when able to merge" do
      before do
        merge_customer.perform
      end

      it "is successful" do
        expect(merge_customer).to be_success
      end

      it "moves the duplicate customers orders to the parent customer" do
        expect(original.reload.orders).to include(order)
      end

      it "sets the parent id on the duplicate customer" do
        expect(duplicate.reload.parent_id).to eq original.id
      end

      it "stores who updated both the original and the duplicate" do
        expect(original.reload.updated_by_id).to eq 55
        expect(duplicate.reload.updated_by_id).to eq 55
      end
    end
  end
end
