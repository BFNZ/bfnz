class ContactList < ApplicationRecord
  belongs_to :territorial_authority, optional: true
  has_many :customers

  scope :for_districts, ->(territorial_authority_ids) {
    if territorial_authority_ids.blank?
      none
    else
      where(territorial_authority_id: territorial_authority_ids)
    end
  }

  def self.create_for_district(district_id, contacts)
    self.transaction do
      contact_list = self.create!(territorial_authority_id: district_id)
      contacts.update_all(contact_list_id: contact_list.id)
      contact_list
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
