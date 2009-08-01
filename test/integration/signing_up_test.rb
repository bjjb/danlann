require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class SigningUpTest < ActionController::IntegrationTest
  fixtures :all

  test "a user signing up for the first time" do
    get "/"
    assert_select 'a.register'
  end
end
