FastGettext.available_locales = [ 'en', 'de', 'pt', 'pt_BR', 'nl', 'es', 'it', 'ru', 'ar', 'fr']
FastGettext.add_text_domain 'app', path: 'locale', type: :po, report_warning: true
FastGettext.default_text_domain = 'app'
FastGettext.default_locale = 'en'

# # enable fallback handling
# I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
# I18n.fallbacks[:"en_US"] = [:"en-US", :en]
# I18n.fallbacks[:"en_GB"] = [:"en-GB", :en]
# I18n.fallbacks[:"pt_BR"] = [:"pt-BR", :pt]
