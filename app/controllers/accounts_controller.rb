class AccountsController < ApplicationController

  only_for_account_administrator :except => [:join, :new]
  before_filter :load_current_account
  before_filter :user_account_is_current_account

  private

  def load_current_account
    @account = Account.find_by_id(params[:id])
  end

  def user_account_is_current_account
    unless @account == current_user.account
      flash[:notice] = 'Invalid Account'
      redirect_to new_session_url
    end
  end

end
