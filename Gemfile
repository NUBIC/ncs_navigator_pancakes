source 'https://rubygems.org'

gem 'aker-rails'
gem 'celluloid'
gem 'ember-rails'
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'ncs_mdes'
gem 'ncs_navigator_configuration', :git => 'https://github.com/NUBIC/ncs_navigator_configuration.git'
gem 'ncs_navigator_authority', :git => 'https://github.com/NUBIC/ncs_navigator_authority.git', :branch => 'configurable-sp-url'
gem 'puma'
gem 'rails', '3.2.13'
gem 'sidekiq'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'hamlbars'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'susy'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'castanet-testing', :git => 'https://github.com/NUBIC/castanet-testing.git'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'foreman', '0.63.0'
  gem 'hana'
  gem 'rack-test'
  gem 'rspec-rails'
  gem 'sinatra'
  gem 'term-ansicolor'

  platform :ruby do
    gem 'therubyracer', :require => false
    gem 'sqlite3'
  end

  platform :jruby do
    gem 'therubyrhino', :require => false
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end
