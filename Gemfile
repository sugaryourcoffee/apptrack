source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Include markdown
gem 'redcarpet'

# Use sqlite3 as the database for Active Record in development
gem 'sqlite3', group: :development

# User MySQL as the database for Active Record in production
gem 'mysql2', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano',         group: :development
gem 'capistrano-bundler', group: :development
gem 'capistrano-rails',   group: :development
gem 'capistrano-rvm',     group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'annotate', group: :development

group :test, :development do
  gem "rspec-rails", "2.13.1"
  gem "guard-rspec", "3.0.3"
end

group :test do
  gem "capybara", "2.1.0"
  gem "rb-inotify", "0.9.2"
  gem "libnotify", "0.8.2"
end
