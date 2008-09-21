module UserSystemHasAccounts
  mattr_accessor :account_grace_period
  self.account_grace_period = 7.days
end
