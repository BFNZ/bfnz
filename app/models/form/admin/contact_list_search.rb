class Form::Admin::ContactListSearch
  include Virtus.model
  include ActiveModel::Model

  attribute :territorial_authority_id, String

  def contactable_orders
    Order.contactable.where(territorial_authority_id: territorial_authority_id).order('created_at desc')
  end

  def selected_ta
    TerritorialAuthority.find_by_id(territorial_authority_id)
  end

  def territorial_authorities
    TerritorialAuthority.all.map { |ta| [ta.name, ta.id] }
  end
end
