class Admin::UpdateOrderDuplicateStatus
  def initialize(params:, duplicate:)
    @params = params
    @duplicate = duplicate
  end

  def order
    @order ||= Order.find(@params[:id])
  end

  def perform
    order.update_attribute(:duplicate, @duplicate)
  end
end
