require 'rails_helper'

describe Item do
  describe ".active" do
    let(:deactivated) { Item.first }

    before do
      deactivated.update_column :deactivated_at, Time.now
    end

    it "returns items that don't have a deactivated at value" do
      expect(Item.active).to match_array Item.all - [deactivated]
    end
  end
end
