# Be sure to restart your server when you modify this file.

default_secret = 'pancakes' * 30
secret_name = 'PANCAKES_SECRET'

if %w(development test ci).include?(Rails.env)
  Pancakes::Application.config.secret_token = ENV[secret_name] || default_secret
else
  Pancakes::Application.config.secret_token = ENV[secret_name] ||
    fail("#{secret_name} is mandatory for #{Rails.env}")
end
