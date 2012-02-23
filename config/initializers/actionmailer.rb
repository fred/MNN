if Rails.env.production? && ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'worldmathaba.net'
  }
  ActionMailer::Base.delivery_method = :smtp
else
  ActionMailer::Base.delivery_method = :sendmail
end