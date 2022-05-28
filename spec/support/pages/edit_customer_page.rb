class EditCustomerPage < CapybaraPage
  attr_reader :customer

  def initialize(customer, &block)
    @customer = customer
    super &block
  end

  def items_select
    'admin_existing_order_form_item_ids'
  end

  def has_order?(order)
    within ".orders" do
      has_text? "Order #{order.identifier}"
    end
  end

  def cancel_order(order)
    expect(page).to have_text "Order #{order.identifier}"
    selected_titles = order.items.map(&:title)
    expect(page).to have_select(items_select, selected: selected_titles)

    click_link "Cancel order"
    expect(page).to have_text "Order cancelled"
    expect(page).not_to have_text "Order #{order.identifier}"
  end

  def add_item_to_order(item, order)
    expect(page).to have_text "Order #{order.identifier}"
    selected_titles = order.items.map(&:title)
    expect(page).to have_select(items_select, selected: selected_titles)

    select item.title, from: items_select
    click_button "Update order"

    expect(page).to have_text "Order #{order.identifier} updated"
    expect(page).to have_select(items_select, selected: (selected_titles << item.title))
  end

  def create_order(item, received_in_person: false)
    click_link "Add new order"
    within "#new_admin_new_order_form" do
      select "Internet", from: "Method received"
      select "Website", from: "Method of discovery"
      select item.title, from: 'admin_new_order_form_item_ids'
      check "This order has already been delivered." if received_in_person
      click_button "Create Order"
    end

    expect(page).to have_text "Order created successfully"

    within "#orders" do
      if received_in_person
        expect(page).to have_text "Date shipped:"
      else
        expect(page).to have_select(items_select, selected: item.title)
      end
    end
  end

  def merge_customer(other_customer)
    orders = other_customer.orders

    click_link "Merge another customer into this one"
    fill_in "Customer #", with: other_customer.id
    click_button "Look up customer"
    within "#merge-preview" do
      expect(page).to have_text "Customer #{other_customer.identifier}"
      orders.each do |order|
        expect(page).to have_text "Order #{order.identifier}"
      end
    end

    click_link "Merge Customer #{other_customer.identifier} into Customer #{customer.identifier}"
    within "#merged-customers" do
      expect(page).to have_text "Customer #{other_customer.identifier}"
    end
    within "#orders" do
      orders.each do |order|
        expect(page).to have_text "Order #{order.reload.identifier}"
      end
    end
  end

  private

  def assert_correct_page
    expect(page).to have_text "Customer ##{customer.id}"
  end
end
