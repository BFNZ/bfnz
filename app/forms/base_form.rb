class BaseForm
  include ActiveModel::Model

  def item_ids=(ids)
    @item_ids = Array(ids).reject(&:blank?).map(&:to_i)
  end
end
