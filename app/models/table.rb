class Table < ActiveRecord::Base
  has_many :orders

  validates_presence_of :location
  validates_presence_of :coordinator_phone
  validates_presence_of :coordinator_email
  validates_presence_of :coordinator_first_name
  validates_presence_of :coordinator_last_name

  def self.test_params
    {location: "vic uni",
     coordinator_phone: "12345678",
     coordinator_email: "regan.ryan.nz@gmail.com",
     coordinator_first_name: "Regan",
     coordinator_last_name: "Ryan"}
  end

  private
  def code
    id.to_s.rjust(4, "0")
  end
end