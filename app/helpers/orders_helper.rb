module OrdersHelper
  def items_for_select(form)
    options_for_select(Item.active.map { |i| [i.title, i.id, {:'data-img-src' => image_path(i.image_path)}] }, form.item_ids)
  end

  def titles_for_select(form)
    options_for_select(['Mr', 'Mrs', 'Miss','Ms'], form.title)
  end

  def discovery_methods_for_select(form)
    options_for_select(method_of_discovery_options, form.method_of_discovery)
  end

  def methods_received_for_select(form)
    options_for_select(method_received_options, form.method_received)
  end
end
