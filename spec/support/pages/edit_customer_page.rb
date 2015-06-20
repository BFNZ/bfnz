class EditCustomerPage < CapybaraPage
  attr_reader :customer

  def initialize(customer, &block)
    @customer = customer
    super &block
  end

  def has_order?(order)
    within ".orders" do
      has_text? "Order ##{order.customer_id}.#{order.id}"
    end
  end

  def merge_customer(other_customer)
    click_link "Merge another customer into this one"
    fill_in "Customer ID", with: other_customer.id
    click_button "Find customer"
    within ".customer_to_merge" do
      has_text? "Customer ##{duplicate_customer.id}"
      other_customer.orders.each do |order|
        has_text? "Order ##{other_customer.id}.#{order.id}"
      end
    end

    click_button "Merge Customer #{other_customer.id} into Customer #{customer.id}"
    within ".merged_customer_records" do
      expect(page).to have_text "Customer ##{other_customer.id}"
    end
    expect(customer.reload.orders.count).to eq 2
    expect(customer.orders.last).to eq order_for_duplicate_customer
  end

  private

  def assert_correct_page
    fail unless title_is_correct?
  end

  def title_is_correct?
    has_text? "Customer ##{customer.id}"
  end

end
