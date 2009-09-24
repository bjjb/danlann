require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "account_confirmation" do
    @expected.subject = 'Notifier#account_confirmation'
    @expected.body    = read_fixture('account_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_account_confirmation(@expected.date).encoded
  end

  test "welcome" do
    @expected.subject = 'Notifier#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_welcome(@expected.date).encoded
  end

  test "password_reset" do
    @expected.subject = 'Notifier#password_reset'
    @expected.body    = read_fixture('password_reset')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_password_reset(@expected.date).encoded
  end

end
