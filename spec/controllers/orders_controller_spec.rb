require 'rails_helper'

create_table_order_params = {
  action: "create_table_order",
  table_id: 1,
  customer_and_order_form: {
    tertiary_student: true,
    tertiary_institution: "Vic Uni",
    title: "Mrs",
    first_name: "Sally",
    last_name: "Exampleman",
    address: "12 Tauranga-A-Ika Street, Manaia 4612",
    suburb: "Manaia",
    city_town: "Manaia",
    post_code: "4612",
    pxid: "2-.C.c.1.I.A",
    dpid: "",
    x: 0.1741220532667E3,
    y: -0.395502671E2,
    ta: "South Taranaki District",
    phone: "12389",
    email: "qwer@req.ew",
    further_contact_requested: 2,
    confirm_personal_order: 1,
    item_ids: [1]
  }
}

RSpec.describe OrdersController do
  before do
    FactoryBot.create(:table, id: 1)
  end

  describe "POST create_table_order" do
    subject { post :create_table_order, params: create_table_order_params }
    it "creates order" do
      expect { subject }.to change(Order, :count).by(1)
    end
    it "marks order with table as method discovered and received" do
      subject
      expect(Order.last).to have_attributes(method_of_discovery: "table_disc",
                                            method_received: "table",
                                            table_id: create_table_order_params[:table_id])
    end
    it "creates shipment" do
      expect { subject }.to change(Shipment, :count).by(1)
    end
    it "creates customer" do
      expect { subject }.to change(Customer, :count).by(1)
    end
  end
end
