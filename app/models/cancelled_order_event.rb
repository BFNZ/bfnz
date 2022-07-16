class CancelledOrderEvent < ApplicationRecord
  belongs_to :cancelled_by, class_name: 'User', optional: true

  serialize :order_details
end
