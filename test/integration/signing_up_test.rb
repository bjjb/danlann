require 'test_helper'

class SigningUpTest < ActionController::IntegrationTest
  test "a user signing up" do
    get "/users/new"
    # Submit user data: Check that the user is created, and the email sent
    assert_emails 0
    assert_difference('User.count', +1) do
      post_via_redirect "/users", :user => {
        :email => "test@example.com",
        :password => "secret",
        :password_confirmation => "secret"
      }
    end
    assert_response :success
    assert_equal  "A confirmation email has been sent to test@example.com",
                  flash[:notice]
    assert_emails 1
    # User should NOT be able to log in yet
    assert_equal false, User.last.confirmed
    get '/login'
    post_via_redirect '/user_sessions', :user_session => {
      :email => 'test@example.com',
      :password => 'secret'
    }
    assert_response :unauthorized
    # Follow link in email: Check that the account is confirmed
    email = ActionMailer::Base.deliveries.last
    assert_equal ['test@example.com'], email.to
    link = email.body[%r|http://.*/users/.*/confirm$|].strip
    get_via_redirect link
    assert_response :success
    assert_equal  "Your account has been confirmed - welcome!",
                  flash[:notice]
    # Now user should be able to log in
    get "/login"
    assert_response :success
    post_via_redirect '/user_sessions', :user_session => {
      :email => 'test@example.com',
      :password => 'secret'
    }
    assert_response :success
    assert_equal "Logged in as test@example.com - welcome!", flash[:notice]
  end
end
