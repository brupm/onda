require 'smtp_tls'

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port    => 587,
  :domain  => "bopia.com",
  :authentication => :plain,
  :user_name => "rubyonda@bopia.com",
  :password => "onda3455ruby"
}