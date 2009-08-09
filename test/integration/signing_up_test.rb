require 'test_helper'

class SigningUpTest < ActionController::IntegrationTest
  fixtures :all

  test "a user signing up for the first time" do
    get "/users/new"
    assert_response :success

    assert_difference "User.count" do
      post_via_redirect "/users",
                        :email => "test@example.com",
                        :password => "secret",
                        :password_confirmation => "secret"
    end
    
    assert_response :success
    assert_equal User.last.email, 'test@example.com'
  end
end
