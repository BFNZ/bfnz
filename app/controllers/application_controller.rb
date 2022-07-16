class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def permit_params
    # Using unpermitted params raise an exception ActiveModel::ForbiddenAttributes.
    # This method permit everything in params to avoid this exception but ideally
    # need to permit only keys used in the action.
    # https://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
    params.permit!
  end
end
