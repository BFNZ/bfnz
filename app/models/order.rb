class Order < ActiveRecord::Base
  has_and_belongs_to_many :items

  enum method_of_discovery: [:unknown, :uni_lit, :non_uni_lit, :other_ad, :word_of_mouth, :website]
  enum method_received: [:mail, :phone, :personally_delivered, :internet, :other]

  validates :title, :first_name, :last_name, :address, presence: true
  validate :contains_at_least_one_item

  def ta=(ta)
    super ta.gsub(/district|city/, "").strip
  end

  def territorial_authority
    @territorial_authority ||= TerritorialAuthority.find_by_addressfinder_name(ta)
  end

  private

  def contains_at_least_one_item
    errors.add(:item_ids, "must be selected") if item_ids.none?
  end
end
