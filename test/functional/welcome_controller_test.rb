require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class WelcomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "welcome_page_has_the_most_recent_pictures" do
    get :index
    assert_equal Picture.most_recent, assigns(:pictures)
  end
end
