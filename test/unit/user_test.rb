require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:bill)
  end

  test "normal creation" do
    user = User.new(
      :email => 'test@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    )
    assert @user.valid?
  end

  test "it has a gravatar" do
    assert_respond_to @user, :gravatar
  end

  test "password must be confirmed" do
    @user.password = "correct"
    assert !@user.valid?
    assert_match /is too short/, @user.errors.on(:password_confirmation)
    @user.password_confirmation = "incorrect"
    assert !@user.valid?
    assert_equal "doesn't match confirmation", @user.errors.on(:password)
    @user.password_confirmation = "correct"
    assert @user.valid?
  end

  test "email must be unique" do
    user = @user.clone
    assert !user.valid?
    assert_equal 'has already been taken', user.errors.on(:email)
  end
end
