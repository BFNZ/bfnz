require 'rails_helper'

describe User do
  describe ".unassigned_coordinators" do
    let(:hamilton) { TerritorialAuthority.find_by_code "016" }
    let!(:assigned_coordinator) { User.make!(:coordinator, territorial_authorities: [hamilton]) }
    let!(:unassigned_coordinator) { User.make!(:coordinator) }
    let!(:admin) { User.make!(:admin) }

    subject { User.unassigned_coordinators }

    it "only returns coordinators who don't have a TA" do
      expect(subject).to match_array [unassigned_coordinator]
    end
  end
end
