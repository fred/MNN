rails_env = ENV['RAILS_ENV'] || 'development'

threads 8,8

bind "unix:///#{`pwd`.strip}/tmp/sockets/puma.sock"
#bind "tcp:///127.0.0.1:3013"

#pidfile "#{`pwd`.strip}/tmp/puma.pid"

