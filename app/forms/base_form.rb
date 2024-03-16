class BaseForm
  include ActiveModel::Model

  def item_ids=(ids)
    @item_ids = Array(ids).reject(&:blank?).map(&:to_i)
  end

  private

  def parse_boolean_value(value)
    return true if value.in?  ["true", "1"]
    return false if value.in? ["false", "0"]
    value
  end

end
