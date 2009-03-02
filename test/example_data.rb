module FixtureReplacement
  attributes_for :account_type do |a|
    a.name = "Test Account Type"
    a.duration = 1 # one month
    a.allowed_users = 5
    a.description = "This is just a test type!"
  end

  attributes_for :account do |a|
    a.last_payment_at = Time.now - 2.days
    a.account_type = default_account_type
    a.name = "TEST ACCOUNT NAME"
  end

  attributes_for :account_administrator, :from => :user do |a|
    a.account = default_account
    a.email = "admin@account.com"
    a.login = "account_admin"
    a.account_administrator = true
  end

  attributes_for :account_request do |a|
  end

  attributes_for :account_request_by_user, :from => :account_request do |a|
    a.user = default_user
    a.administrator_email = 'admin@account.com'
  end

  attributes_for :account_request_by_account, :from => :account_request do |a|
    a.account = default_account
    a.user_email = 'admin@account.com'
  end
end
