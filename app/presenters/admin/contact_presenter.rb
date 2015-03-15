class Admin::ContactPresenter
  def initialize(order)
    @order = order
  end

  delegate :id, :first_name, :last_name, :address, to: :order

  def created
    "#{order.created_at.to_s(:display)}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  attr_reader :order

end
