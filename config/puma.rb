rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind "unix:///#{`pwd`.strip}/tmp/sockets/puma.sock"

#pidfile "#{`pwd`.strip}/tmp/puma.pid"

#bind "tcp:///127.0.0.1:3013"

