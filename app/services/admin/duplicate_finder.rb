require 'spreadsheet'
require 'csv'


class Admin::DuplicateFinder

  CSV_HEADERS = ["master_id","duplicate_type","customer_id","title","first_name","last_name","address","email","phone","ip_address","cust_create_date","admin_notes","order_id","order_items","order_date","ship_date","created_by"]

  def csv
    rows = [CSV_HEADERS]
    unshipped_customers = Customer.where(id: Order.ready_to_ship.pluck(:customer_id)).includes(orders: [:items, :created_by])

    unshipped_customers.each do |customer|
      duplicate_found = false
      duplicate_found = true if customer.pxid.blank?

      duplicates = {
        address: find_address_duplicates(customer),
        full_name: find_full_name_duplicates(customer),
        phone: find_phone_duplicates(customer),
        email: find_email_duplicates(customer),
        ip_address: find_ip_address_duplicates(customer),
      }.compact

      duplicate_found ||= duplicates.any?

      next unless duplicate_found
      rows << dup_print_line_header(customer, "Master")
      rows << dup_print_line_header(customer, "Address not matched") if customer.pxid.blank?

      duplicates.each do |duplicate_type, dups|
        dups.each do |duplicate_customer|
          if duplicate_type == :ip_address
            order = duplicate_customer
            duplicate_customer = order.customer
          else
            order = duplicate_customer.orders.first
          end
          rows << export_line_to_csv(duplicate_type, duplicate_customer, order, customer)
        end
      end
      # We need to test this compared to the rake task to see if ouput is the same
    end.compact

    rows.map {|row| row.to_csv}.join
  end

  def find_full_name_duplicates(master_customer)
    return unless (master_customer.last_name.present? && master_customer.first_name.present?)

    duplicate_by_name = Customer.where("lower(first_name) = ? and lower(last_name) = ? and id < ?",
                                        master_customer.first_name.downcase,
                                        master_customer.last_name.downcase,
                                        master_customer.id).includes(:orders).presence
  end

  def find_address_duplicates(master_customer)
    return unless master_customer.pxid.present?

    Customer.where("pxid = ? and id < ?", master_customer.pxid, master_customer.id)
  end

  def find_phone_duplicates(master_customer)
    return unless master_customer.phone.present?

    # joins to ignore customer records with no orders - i.e. merged records.
    Customer.joins(:orders).where("customers.phone = ? and customers.id < ?", master_customer.phone, master_customer.id)
  end

  def find_email_duplicates(master_customer)
    return unless master_customer.email.present?

    #joins to ignore customer records with no orders - i.e. merged records.
    Customer.joins(:orders).where("customers.email = ? and customers.id < ?", master_customer.email, master_customer.id)
  end

  def find_ip_address_duplicates(master_customer)
    latest_customer_order = Order.where("customer_id = ?", master_customer.id).last
    return unless latest_customer_order.ip_address.present?

    Order.where("Ip_Address = ? and id < ?", latest_customer_order.ip_address, latest_customer_order.id).includes(:customer)
  end

  def dup_print_line_header (customer, duplicate_type)
    order = customer.orders.first {|order| order.shipment_id == nil}
    item_codes = order.items.map(&:code).join
    user_name = order.created_by&.name.to_s
    customer_id = duplicate_type == "Master" ? customer.id : "-- #{customer.id}"

    [customer_id,duplicate_type,customer.id,customer.title, customer.first_name,customer.last_name,customer.address,customer.email,customer.phone.to_s,order.ip_address,customer.created_at,customer.admin_notes, order.id, item_codes,order.created_at,'',user_name]
  end

  def export_line_to_csv(type, duplicate_customer, order, master_customer)
    item_codes = order.items.map(&:code).join if order.present?
    ["--#{master_customer.id}",type.to_s,duplicate_customer.id,duplicate_customer.title,
      duplicate_customer.first_name,duplicate_customer.last_name,duplicate_customer.address,
      duplicate_customer.email,duplicate_customer.phone.to_s,order&.ip_address,duplicate_customer.created_at,
      duplicate_customer.admin_notes, order&.id, item_codes,order&.created_at,'',order&.created_by&.name]
  end
end
