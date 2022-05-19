require 'rails_helper'

RSpec.describe CustomerAndOrderForm do
  subject(:form) { described_class.new(attrs) }

  describe "validation" do
    context "when item_ids is empty" do
      let(:attrs) { {:item_ids => [""]} }

      it "is not valid" do
        expect(form).not_to be_valid
        expect(form.errors[:item_ids]).to eq ["You must select at least one item"]
      end
    end
  end
end
