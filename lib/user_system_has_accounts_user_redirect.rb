# Add callback methods into UserRedirect
# for late payments and missing accounts
module UserSystemHasAccountsUserRedirect

  private
  def join_account user
    if user.account.nil? and UserSystem.all_users_must_have_account
      redirect_to join_accounts_path
      false
    else
      true
    end
  end

  def renew_account user
    if user.account and user.account.suspended?
      redirect_to renew_account_path(user.account)
    else
      true
    end
  end
end
