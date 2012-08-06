# Use the following command to setup S3 credentials on Heroku
# $ heroku config:add S3_KEY=123key S3_SECRET=456secret S3_BUCKET=my_app_production S3_REGION=region
#
# or the following command if not on Heroku, ie. Unix
# $ export S3_KEY='fill_in_your_key_here'
# $ export S3_SECRET='fill_in_your_secret_key_here'
# $ export S3_BUCKET='fill_in_your_bucket_name_here'
# $ export S3_REGION='us-west-1'

CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  if Rails.env.test? or Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
  else
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_credentials = {
      provider:               'AWS',               # required
      aws_access_key_id:      ENV["S3_KEY"],       # required
      aws_secret_access_key:  ENV["S3_SECRET"],    # required
      region:                 ENV['S3_REGION'],    # optional, defaults to 'us-east-1'
      persistent:             false
    }
    config.fog_directory    = ENV['S3_BUCKET']         # required
    config.fog_attributes   = {'Cache-Control'=>'max-age=604800'}  # 1 week, optional, defaults to {}
  end
end

Excon.defaults[:ssl_verify_peer] = false
