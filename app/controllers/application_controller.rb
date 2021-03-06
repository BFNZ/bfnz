class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
