class CancelledOrderEvent < ActiveRecord::Base
  belongs_to :cancelled_by, class_name: 'User'

  serialize :order_details
end
