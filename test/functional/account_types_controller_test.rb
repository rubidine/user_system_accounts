require File.join(File.dirname(__FILE__), '..', 'test_helper')

context 'The Accounts Controller' do
  setup do
    @controller = AccountTypesController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @account_type = create_account_type
  end

  it 'should list all public account types with descriptions' do
    get 'index'
    assert_response 200
    assert_select "div#account_type_#{@account_type.id}", 1
  end

  it 'should not list an account_type if it is not public' do
    @account_type.update_attribute :public, false
    get 'index'
    assert_response 200
    assert_select "div#account_type_#{@account_type.id}", false
  end

end
