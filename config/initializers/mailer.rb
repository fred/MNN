# Use :test mode for test env, and check if postmark is installed for dev and prod env.
if Rails.env.production?
  if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
    ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => 'worldmathaba.net'
    }
    ActionMailer::Base.delivery_method = :smtp
  elsif ENV['POSTMARK_KEY'] && ActionMailer::Base.delivery_methods.has_key?(:postmark) && defined?(Postmark)
    ActionMailer::Base.delivery_method = :postmark
    ActionMailer::Base.postmark_settings = { api_key: ENV['POSTMARK_KEY'] }
    Postmark.api_key = ENV['POSTMARK_KEY']
    Postmark.secure = true
  else
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
      :address        => 'localhost',
      :port           => '25',
      :domain         => 'worldmathaba.net'
    }
  end
end