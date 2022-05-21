module Admin::OrdersHelper
  def territorial_authorities_for_select(form)
    options_for_select(TerritorialAuthority.all.map { |ta| [ta.name, ta.name] }, form.ta)
  end

  def method_of_discovery_options
    Order.method_of_discoveries.map do |k,v|
      case k.to_s
      when 'mail_disc'
        ['Mail', k]
      when 'other_disc'
        ['Other', k]
      else
        [k.humanize,k]
      end
    end
  end

  def method_received_options
    Order.method_receiveds.map { |k,v| [k.humanize,k] }
  end
end
