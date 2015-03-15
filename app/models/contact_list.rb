class ContactList < ActiveRecord::Base
  belongs_to :territorial_authority
  has_many :orders

  scope :for_ta, ->(territorial_authority) {
    if territorial_authority.nil?
      none
    else
      where(territorial_authority_id: territorial_authority.id)
    end
  }

  def self.create_for_orders(territorial_authority, orders)
    self.transaction do
      contact_list = self.create!(territorial_authority: territorial_authority)
      orders.update_all(contact_list_id: contact_list.id)
    end
  end

  def filename
    "#{ta_name}_contacts_#{created_at.to_s(:csv)}"
  end

  private

  def ta_name
    territorial_authority.name.downcase.gsub(/ /,'_')
  end

end
