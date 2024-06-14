class Admin::UsersController < Admin::BaseController
  before_action :require_user
  before_action :require_superadmin, only: [:edit, :update]

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Password updated successfully.'
    else
      render :edit
    end
  end

  private

  def current_user
    @current_user ||= UserSession.find&.user
  end

  def user_signed_in?
    current_user.present?
  end

  def require_user
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this page"
      redirect_to new_user_session_path
    end
  end

  def require_superadmin
    unless current_user.superadmin?
      flash[:error] = "You must be a superadmin to access this page"
      redirect_to admin_users_path
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  helper_method :current_user, :user_signed_in?
end
