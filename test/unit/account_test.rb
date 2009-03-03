require File.join(File.dirname(__FILE__), '..', 'test_helper')
context 'Account' do

  setup do
    @account = create_account
  end

  it 'Will inform if payment is late' do
    @account.next_payment_at = Date.today - 1
    assert @account.overdue?
  end

  it 'Can be suspended for non-payment' do
    @account.next_payment_at = Date.today - UserSystem.account_grace_period - 1
    assert @account.suspended?
  end

  it 'Will not allow too many users to join' do
    Account.update_all(
      {:users_count => 5},
      {:id => @account.id}
    )
    @account.reload
    assert_equal 5, @account.users_count
    assert_equal 5, @account.account_type.allowed_users
    @user = User.new :login => 'asdf', :passphrase => 'bcd'
    @user.account = @account
    @user.valid?
    assert @user.errors.on(:account)
  end

  it 'Will not mass-assign attributes' do
    @account.update_attributes(:users_count => 990, :account_type_id => 700, :last_payment_at => (Date.today + 1), :next_payment_at => (Date.today + 2))
    @account.reload
    assert_not_equal 990, @account.users_count
    assert_not_equal 700, @account.account_type_id
    assert_not_equal (Date.today + 1), @account.last_payment_at
    assert_not_equal (Date.today + 2), @account.next_payment_at
  end

  it 'will set a default slug' do
    assert @account.slug
  end
end
