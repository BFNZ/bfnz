require 'rails_helper'

describe Item do
  describe ".active" do
    it "returns items that don't have a deactivated at value" do
      Item.active.each do |item|
        expect(item.deactivated_at).to be_nil
      end
    end
  end
end
