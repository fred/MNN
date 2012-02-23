AKISMET_KEY=ENV["AKISMET_KEY"].to_s

if defined?(Rakismet)
  Publication::Application.config.rakismet.key = AKISMET_KEY
  Publication::Application.config.rakismet.url = 'http://worldmathaba.net/'
end
