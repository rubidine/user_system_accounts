module UserSystemHasAccounts
  mattr_accessor :account_grace_period
  self.account_grace_period = 7.days

  mattr_accessor :all_users_must_have_account
  self.all_users_must_have_account = true

  mattr_accessor :default_account_invite_message
  self.default_account_invite_message = "Please join my account!"
end
