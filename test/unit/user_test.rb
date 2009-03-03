require File.join(File.dirname(__FILE__), '..', 'test_helper')
context 'User' do
  setup do
  end

  it 'will create new account if account type/name set and account is not' do
    at = create_account_type
    user = create_user(:account_type => at, :new_account_name => 'testact')
    User.logger.warn "--CREATED"
    user.reload
    User.logger.warn "--RELOADED"
    assert user.account
    User.logger.warn "--ASSERTED"
    assert_equal 1, user.account.users.count
    User.logger.warn "--COUNTED"
    assert_equal 1, user.account.users_count
    User.logger.warn "--FINISHED"
  end

  it 'will have account_type denormalized for them if account changes' do
    a = create_account
    user = create_user(:account => a)
    assert user.account_type
  end

end

