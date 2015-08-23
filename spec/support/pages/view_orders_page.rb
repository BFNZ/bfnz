class ViewOrdersPage < CapybaraPage

  def assert_correct_page
    within "h2" do
      expect(page).to have_text "Search Orders"
    end
  end

  def edit(name)
    find(:xpath, "//tr[contains(.,'#{name}')]").click_link("Edit")
  end

  def search_by(attrs)
    attrs.each do |field, value|
      fill_in(field, with: value)
    end
    click_button "Search"
  end

  def export_to_csv
    click_button "Export to CSV"
  end

  def assert_expected_results(count)
    expect(page).to have_text "#{count} order"
  end

  def assert_csv_headers
    header = page.response_headers['Content-Disposition']
    expect(header).to match /^attachment/
    expect(header).to match /filename="orders.csv"$/
  end

  def assert_csv_content
    expect(page).to have_text "ID,Title,First name,Last name,Street address,Suburb,City/Town,Postcode,Region,Phone,Email,Method of discovery,Created at,IP address,Method received,Tertiary student,Tertiary institution,Shipment ID,Shipped at"
  end
end
