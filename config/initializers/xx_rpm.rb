if Rails.env.production?
  require 'newrelic_rpm'
  ::NewRelic::Agent.manual_start
  ::NewRelic::Agent.after_fork(force_reconnect: true) if defined? Unicorn
end