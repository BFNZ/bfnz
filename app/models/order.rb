class Order < ActiveRecord::Base
  enum method_of_discovery: [:website] #todo
  enum further_contact_by: [:phone, :email] #todo

  belongs_to :place
end
