class AccountsController < ApplicationController
  before_filter :require_user

  def update
    @user = current_user

    respond_to do |format|
      @user.attributes= params[:user]
      if @user.save
        flash[:notice] ||= 'Your account has been updated.'
        format.html { redirect_to(account_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @user = current_user
  end

  def show
    @user = current_user
  end
end
