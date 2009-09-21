# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user, :admin_only, :rake

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def authorize
    unless current_user_session
      flash[:message] = "You have to log in first"
      redirect_to login_url
    end
  end

  def admin_only
    unless current_user and current_user.admin?
      flash[:notice] = "You must be an administrator to do that"
      redirect_to login_path
    end
  end

end
