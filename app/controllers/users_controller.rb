class UsersController < ApplicationController
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        url = confirm_user_url(:id => @user.perishable_token)
        Notifier.deliver_account_confirmation(@user, url)
        flash[:notice] = "A confirmation email has been sent to #{@user.email}"
        format.html { redirect_to(root_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def confirm
    @user = User.find_using_perishable_token(params[:id])
    if @user
      @user.reset_perishable_token
      @user.confirmed = true
      if @user.save
        flash[:notice] = "Your account has been confirmed - welcome!"
        UserSession.create(@user)
        redirect_to root_url
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
