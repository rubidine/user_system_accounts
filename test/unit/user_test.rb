require File.join(File.dirname(__FILE__), '..', 'test_helper')
context 'User' do
  setup do
  end

  it 'will create new account if account_type is set and account is not' do
    at = create_account_type
    user = create_user(:account_type => at)
    user.reload
    assert user.account
    assert_equal 1, user.account.users_count
  end

  it 'will have account_type denormalized for them if account changes' do
    a = create_account
    user = create_user(:account => a)
    assert user.account_type
  end

end

