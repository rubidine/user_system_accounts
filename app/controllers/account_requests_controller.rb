class AccountRequestsController < ApplicationController

  def new
    @account_request = current_account.account_requests.new
  end

  def create
    unless current_account.can_invite_users?
      render :text => "Account full!"
      return
    end

    @req = current_account.account_requests.create(params[:account_request])
  end

  def show
    @account_request = current_account.account_requests.find_by_security_token(params[:id])
    @user = @account_request.dummy_user_model
  end

end
