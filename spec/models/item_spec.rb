require 'rails_helper'

describe Item do
  describe ".active" do
    let!(:active_item) { Item.create!(title: "I'm active!", code: "a") }
    let!(:inactive_item) { Item.create!(title: "I was deactivated", code: "d", deactivated_at: Time.now) }

    it "returns items that don't have a deactivated at value" do
      expect(Item.active).to match_array [active_item]
    end
  end
end
