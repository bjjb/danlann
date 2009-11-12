require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "/login is an alias for /new" do
    assert_generates '/login', :controller => "user_sessions", :action => "new"
  end

  test "/logout is an alias for /destroy" do
    assert_generates '/functional', :controller => "user_sessions", :action => "destroy"
  end

end
