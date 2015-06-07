class ViewOrdersPage < CapybaraPage

  def initialize
    visit "/admin/orders"
  end

  def edit(name)
    find(:xpath, "//tr[contains(.,'#{name}')]").click_link("Edit")
  end
end
