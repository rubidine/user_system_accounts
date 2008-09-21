require File.join(File.dirname(__FILE__), '..', 'test_helper')

context 'The Users Controller' do
  setup do
    @controller = UsersController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @account_type = create_account_type
  end

  it 'should be able to select account type during signup' do
    get 'new'
    assert_response 200
    assert_select "select#user_account_type_id"
  end

end
