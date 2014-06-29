require 'rails_helper'

describe Order do
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
