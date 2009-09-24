class UserSessionsController < ApplicationController
  def index
    if current_user
      redirect_to edit_user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_back_or_default root_url
    else
      render 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_back_or_default root_url
  end
end 
