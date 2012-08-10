if (RUBY_PLATFORM == 'java')
  module ActiveRecord::ConnectionAdapters
    if defined?(JdbcAdapter)
      class JdbcAdapter < AbstractAdapter
        def explain(*args)
          # Do nothing :'(
        end
      end
    end
  end
end