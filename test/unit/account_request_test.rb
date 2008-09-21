require File.join(File.dirname(__FILE__), '..', 'test_helper')

context 'AccountRequest' do
  context 'created by user' do
    setup do
      @user = create_account_administrator
      @req = create_account_request_by_user
    end

    it 'should be approved by user' do
      assert @req.approved_by_user?
    end
  end

  
end
