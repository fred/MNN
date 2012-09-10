if defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.authorization_mode = :whitelist
end