class Admin::ContactLists::ContactView
  def initialize(customer)
    @customer = customer
  end

  delegate :id, :title, :first_name, :last_name, :address, to: :customer

  def created
    "#{customer.created_at.to_s(:display)}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  attr_reader :customer

end
