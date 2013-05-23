# This file is used by Rack-based servers to start the application.

ENV['PANCAKES_SERVER'] = true

require ::File.expand_path('../config/environment',  __FILE__)
run Pancakes::Application
