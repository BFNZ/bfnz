require 'rails_helper'

RSpec.describe OrderMailer do

  describe "#confirmation_email" do
    subject(:email) { described_class.confirmation_email(order).deliver }

    let(:order) { Order.new(email: 'myemail@gmail.com', first_name: 'Jane', last_name: 'Doe') }

    it { expect(email.from).to eq ["info@biblesfornewzealand.org.nz"] }
    it { expect(email.to).to eq ['myemail@gmail.com'] }
    it { expect(email.subject).to eq "Thank you for your request for free literature from Bibles for New Zealand" }
    it { expect(email.parts[0].body.to_s).to match /Dear Jane Doe/ }
  end
end
