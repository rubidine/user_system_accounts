module UserModelHasAccount
  def self.included kls
    kls.send :before_validation, :denormalize_account_type
    kls.send :validate, :validate_account_has_space
    kls.send :before_create, :create_account_if_account_type_without_account

    kls.send :belongs_to, :account, :counter_cache => true
    kls.send :belongs_to, :account_type

    kls.send :named_scope, :account_administrator, {:conditions => {:account_administrator => true}}

    kls.send :attr_accessor, :new_account_name
    kls.send :attr_protected, :account_administrator
  end

  private
  def denormalize_account_type
    # force if account has changed
    if changes['account_id'] and account
      self.account_type = account.account_type
    end

    # default
    self.account_type ||= account.account_type if account

    true
  end

  def validate_account_has_space
    return true unless changes['account_id']
    return true unless account_type
    return true if account_type.unlimited_users?
    return true unless account
    # XXX race condition
    return true if (account_type.allowed_users - 1) > account.users_count
    errors.add(:account, 'has too many users')
    false
  end

  def create_account_if_account_type_without_account
    return true if account
    return true unless account_type

    act = Account.new
    # manually write attr_protected fields
    act.name = new_account_name
    act.account_type = account_type

    unless act.save
      if UserSystem.all_users_must_have_account
        errors.add(:account_name, "unable to create_account: #{account.errors.full_messages.inspect}")
        destroy
      end
      false
    else
      self.account = act
      self.account_administrator = true
      true
    end
  end

end
