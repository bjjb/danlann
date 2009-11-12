class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in as #{current_user.email} - welcome!"
      redirect_back_or_default root_url
    else
      render 'new', :status => :unauthorized
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "You've been logged out."
    redirect_back_or_default root_url
  end
end 
