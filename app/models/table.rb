class Table < ApplicationRecord
  has_many :orders

  validates_presence_of :location
  validates_presence_of :city
  validates_presence_of :coordinator_phone
  validates_presence_of :coordinator_email
  validates_presence_of :coordinator_first_name
  validates_presence_of :coordinator_last_name

  def code
    id.to_s.rjust(4, "0")
  end

end
