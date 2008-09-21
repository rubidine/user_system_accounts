module UserModelHasAccount
  def self.included kls
    kls.send :belongs_to, :account, :counter_cache => true
    kls.send :belongs_to, :account_type
    kls.send :before_validation, :set_account_type
    kls.send :validate, :validate_account_has_space
    kls.send :after_create, :create_account_if_account_type_without_account
    kls.send :named_scope, :account_administrator, {:conditions => {:account_administrator => true}}
  end

  private
  def set_account_type
    # force if account has changed
    if changes['account_id'] and account
      self.account_type = account.account_type
    end

    # default
    self.account_type ||= account.account_type if account
  end

  def validate_account_has_space
    return true unless changes['account_id']
    return true unless account_type
    return true if account_type.unlimited_users?
    return true unless account
    return true if (account_type.allowed_users - 1) > account.users_count
    errors.add(:account, 'has too many users')
    false
  end

  def create_account_if_account_type_without_account
    return true if account
    return true unless account_type
    self.account = Account.create(:account_type => account_type)
    self.account_administrator = true
    save
  end

end
