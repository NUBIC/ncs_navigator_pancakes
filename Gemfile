source 'https://rubygems.org'

gem 'aker-rails'
gem 'ember-rails'
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'ncs_mdes'
gem 'ncs_navigator_configuration', :git => 'https://github.com/NUBIC/ncs_navigator_configuration.git'
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
  gem 'cucumber-rails', :require => false
  gem 'rspec-rails'
  gem 'hana'

  platform :ruby do
    gem 'therubyracer', :require => false
  end

  platform :jruby do
    gem 'therubyrhino', :require => false
  end
end
