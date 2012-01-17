if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'herokuapp.com'
  }
  ActionMailer::Base.delivery_method = :smtp
else
  ActionMailer::Base.delivery_method = :sendmail
end