require 'rails_helper'

RSpec.describe TablesController do
  fdescribe "GET show" do
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
end