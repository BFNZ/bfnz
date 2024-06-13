class Admin::BaseController < ApplicationController
  before_action :require_admin
  helper_method :current_user_session, :current_user
  layout 'admin'

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_admin
    unless current_user && current_user.admin?
      store_location
      flash[:notice] = "Sorry, you don't have access to this page"
      redirect_to login_path
      return false
    end
  end

  def require_superadmin
    unless current_user.superadmin?
      flash[:error] = "You must have special permissions to access this page"
      redirect_to login_path
    end
  end

  def store_location
    session[:return_to] = request.path
  end
end
