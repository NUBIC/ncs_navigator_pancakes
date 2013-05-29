source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.7.0'
gem 'aker-rails'
gem 'bcdatabase'
gem 'castanet'
gem 'celluloid'
gem 'connection_pool'
gem 'ember-rails'
gem 'ember-source', '1.0.0.rc3'
gem 'faraday'
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'ncs_mdes'
gem 'ncs_navigator_configuration', :git => 'https://github.com/NUBIC/ncs_navigator_configuration.git'
gem 'ncs_navigator_authority', :git => 'https://github.com/NUBIC/ncs_navigator_authority.git'
gem 'rb-readline'
gem 'puma'
gem 'rails', '3.2.13'
gem 'sidekiq'

platform :ruby do
  gem 'pg'
  gem 'therubyracer', :require => false
end

platform :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'therubyrhino', :require => false
end

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'hamlbars'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'susy'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'aker-cas_cli'
  gem 'castanet-testing', :git => 'https://github.com/NUBIC/castanet-testing.git'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'foreman', '0.63.0'
  gem 'hana'
  gem 'rack-test'
  gem 'rspec-rails'
  gem 'sinatra'
  gem 'term-ansicolor'
  gem 'vlad', :require => false
  gem 'vlad-extras', :require => false
  gem 'vlad-git', :require => false
end
