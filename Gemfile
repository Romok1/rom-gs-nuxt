source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'inline_svg'
gem 'sidekiq', '~> 5.2'
gem 'sidekiq-status', '~> 1.1.4'

gem 'mimemagic','~>0.3.10'

gem 'devise'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem 'appsignal'
gem 'comfortable_mexican_sofa', '~> 2.0.0'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
gem 'loofah', '>= 2.2.3'
gem 'rack', '>= 2.0.6'
gem 'webpacker', '~> 4.0.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem 'byebug', platforms: %i[mri mingw x64_mingw]

gem 'globalize'
gem 'i18n-js'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'awesome_print'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano', '~> 3.11.0', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-nvm'
  gem 'capistrano-passenger', '~> 0.1.1', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'capistrano-service'
  gem 'capistrano-yarn'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'net-ssh', '7.0.0.beta1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'sql_tracker'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'whenever', '~> 1.0', require: false
