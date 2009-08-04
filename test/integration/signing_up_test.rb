require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class SigningUpTest < ActionController::IntegrationTest
  fixtures :all

  test "a user signing up for the first time" do
    https!
    get "/register"
    assert_response :success

    post_via_redirect "/users",
                      :email => "test@example.com",
                      :password => "secret",
                      :password_confirmation => "secret"
    
    assert_equal  "Thanks for signing up, test@example.com",
                  flash[:notice]

    assert_not_nil User.last.single_access_token

    https!(false)
  end
end
