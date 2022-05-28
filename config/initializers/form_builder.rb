class ActionView::Helpers::FormBuilder
  def required_label(method, options={})
    label_text = options[:label_text] || method.to_s.titleize
    label method, "#{label_text}#{@template.content_tag(:span, '*', class: 'required')}".html_safe, options
  end
end
