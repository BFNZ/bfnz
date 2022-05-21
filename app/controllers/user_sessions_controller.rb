class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      redirect_back_or_default admin_root_path
    else
      flash[:error] = "Incorrect credentials, please try again."
      render 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end
