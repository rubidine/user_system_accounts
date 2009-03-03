module UserSystemHasAccountsSessionsController
  private
  def self.included kls
    kls.send :alias_method_chain, :login_scope, :accounts
  end

  def login_scope_with_accounts
    login_scope_without_accounts.for_account(current_account)
  end
end
