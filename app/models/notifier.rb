class Notifier < ActionMailer::Base
  
  cattr_accessor :mailer
  mailer = "Notifier <no-reply@pictures.bjjb.org>"

  def account_confirmation(user, url)
    subject    'Please confirm your account'
    recipients user.email
    from       mailer
    body       :url => url
  end

  def welcome(user)
    subject    'Welcome!'
    recipients user.email
    from       mailer
    body       :user => user
  end

  def password_reset(user, url)
    subject    'Forgot your password?'
    recipients user.email
    from       mailer
    body       :url => url
  end

end
