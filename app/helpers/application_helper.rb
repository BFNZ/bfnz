module ApplicationHelper

  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info",
    }[flash_type.to_sym] || flash_type
  end

  def active_if_current_page(controller, action)
    'active' if controller == controller_name.to_sym && action == action_name.to_sym
  end
end
