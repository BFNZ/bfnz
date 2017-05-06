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
    confirm_personal_order: true,
    item_ids: [1]
  }
}

RSpec.describe OrdersController do
  describe "POST create_table_order" do
    subject { post :create_table_order, create_table_order_params }
      it "creates order" do
        expect { subject }.to change(Order, :count).by(1)
      end
      it "marks order already shipped, with table as method discovered and received" do
        subject
        expect(Order.last.method_of_discovery).to eq("table_disc")
        expect(Order.last.method_received).to eq("table")
        expect(Order.last.table_id).to eq(create_table_order_params[:table_id])
        expect(Order.last.shipped_before_order).to eq true
      end
  end
end