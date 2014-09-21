module OrdersHelper
  def items_for_select
    options_for_select(Item.active.map { |i| [i.title, i.id, {:'data-img-src' => image_path(i.image_path)}] }, @order.item_ids)
  end
end
