# Add callback methods into UserRedirect
# for late payments and missing accounts
module UserSystemHasAccountsUserRedirect

  private
  def join_account user
    if user.account.nil?
      redirect_to join_accounts_path
    end
  end

  def renew_account user
    if user.account.suspended?
      redirect_to renew_account_path(user.account)
    end
  end
end
