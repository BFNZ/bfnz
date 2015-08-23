require 'rails_helper'

describe Admin::OrderSearchForm do
  describe "#item_ids_options" do
    subject(:item_ids_options) { described_class.new.item_ids_options }

    it "returns the titles and ids of all items" do
      expect(item_ids_options).
        to match_array [["The New Testament Recovery Version", 1],
                        ["The All Inclusive Christ", 2],
                        ["The Glorious Church", 3],
                        ["Basic Elements of the Christian Life", 4],
                        ["The Economy of God", 5],
                        ["The Knowledge of Life", 6]]
    end
  end

  describe "#shipped_options" do
    subject(:shipped_options) { described_class.new.shipped_options }

    it { expect(shipped_options).to match_array [["Yes", 1], ["No", 0]] }
  end

  describe "#filtered_orders" do
    subject(:filtered_orders) { described_class.new(attrs).filtered_orders }

    let!(:order) { Order.make! }
    let!(:shipped_order) { Order.make!(:shipped) }
    let!(:jan_order) { Timecop.freeze(Date.new(2014,1,3)) { Order.make! } }
    let!(:further_contact_order) { Order.make!(customer: Customer.make!(further_contact_requested: true)) }

    context "when no attrs are passed in" do
      let(:attrs) { {} }

      it "returns all orders" do
        expect(filtered_orders).to match_array Order.all
      end
    end

    context "when shipped is passed in" do
      let(:attrs) { {shipped: 1} }

      it "scopes orders by shipped" do
        expect(filtered_orders).to eq [shipped_order]
      end
    end

    context "when created_at from and to are passed in" do
      let(:attrs) { {created_at_from: '2014-01-01', created_at_to: '2014-01-31'} }

      it "scopes orders by created_at" do
        expect(filtered_orders).to eq [jan_order]
      end
    end

    context " when further_contact_requested is set to true" do
      let(:attrs) { {further_contact_requested: true} }

      it "scopes orders by further_contact_requested" do
        expect(filtered_orders).to eq [further_contact_order]
      end
    end
  end

  describe "#item_ids" do
    subject(:order_search_form) {
      described_class.new(item_ids: [Item.first.id, "hi", "", nil]) }

    it "ignores invalid item ids" do
      expect(order_search_form.item_ids).to eq [Item.first.id]
    end
  end
end
