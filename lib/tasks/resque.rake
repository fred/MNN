# require 'resque/tasks'
# 
# task "resque:setup" => :environment do
#   # ENV['QUEUE'] = '*'
#   # for redistogo on heroku
#   # https://gist.github.com/1316470
#   Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
# end