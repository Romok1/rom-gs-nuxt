I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
I18n.available_locales = [:en, :es, :rt]
I18n.default_locale = :en
