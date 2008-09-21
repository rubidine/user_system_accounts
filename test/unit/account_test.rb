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
    @account.update_attribute(:users_count, 5)
    @user = new_user(:account_id => @account.id)
    @user.valid?
    assert @user.errors.on(:account)
  end

end
