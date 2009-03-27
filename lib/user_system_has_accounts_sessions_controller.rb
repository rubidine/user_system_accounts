module UserSystemHasAccountsSessionsController
  private
  def self.included kls
    unless kls.private_instance_methods.include?('login_scope_without_accounts')
      kls.send :alias_method_chain, :login_scope, :accounts
    end
  end

  private
  def login_scope_with_accounts
    login_scope_without_accounts.for_account(current_account)
  end
end
