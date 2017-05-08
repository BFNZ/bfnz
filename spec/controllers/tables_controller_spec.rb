require 'rails_helper'

RSpec.describe TablesController do
  describe "GET show" do
    subject { get :show }
    context "when no cookies exist" do
      it { is_expected.to redirect_to(new_table_path)}
    end
    context "when cookie exists" do
      before do
        table = FactoryGirl.create :table
        request.cookies['bfnz_table'] = table.id
      end
      it { is_expected.to render_template "show" }
    end
  end
  describe "POST create" do
    subject { post :create, table: FactoryGirl.attributes_for(:table) }
    it "creates table" do
      expect { subject }.to change(Table, :count).by(1)
    end
    it "table has attributes" do
      subject
      expect(Table.last).to have_attributes(FactoryGirl.attributes_for(:table))
    end
    it "bakes cookies" do
      subject
      expect(!!response.cookies["bfnz_table"]).to eq true
    end
  end
end