rails_env = ENV['RAILS_ENV'] || 'development'

threads 8,8

bind "unix:///#{`pwd`.strip}/tmp/sockets/puma.sock"

#pidfile "#{`pwd`.strip}/tmp/puma.pid"

#bind "tcp:///127.0.0.1:3013"

