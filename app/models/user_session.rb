class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages true
  consecutive_failed_logins_limit 10
end
