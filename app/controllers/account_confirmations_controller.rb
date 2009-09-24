class AccountConfirmationsController < ApplicationController
  before_filter :require_no_user

  def show
    @user = User.find_using_perishable_token(params[:id])
    if @user
      @user.reset_perishable_token # TODO - see if the token needs resetting
      @user.confirmed = true
      if @user.save
        flash[:notice] = "Your account has been confirmed - welcome!"
        redirect_to root_url
        UserSession.create(@user)
      else
        flash[:error] = "Something went wrong confirming your account! " +
          "Please try the signup procedure again. If you continue to " +
          "encounter difficulties, contact me."
        redirect_to root_url
      end
    else
      flash[:error] = "The confirmation link you provided is not valid. " +
        "If you copied and pasted it, please double check that the URL is " +
        "the same as that received in the email. Failing that, try signing " +
        "up again, or contact me"
      redirect_to root_url
    end
  end
end
