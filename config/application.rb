require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_record/railtie"
require "sprockets/railtie"

require 'ncs_navigator/configuration'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Pancakes
  def app_server?
    ENV['PANCAKES_SERVER']
  end

  module_function :app_server?

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Make custom fonts accessible to the asset pipeline
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

    # Turn on threadsafe mode
    config.threadsafe!

    # Set MDES version and other NCS Navigator bits
    config.before_initialize do
      ncs_config = NcsNavigator::Configuration.new(config.navigator_ini_path)

      config.ncs_config = ncs_config
      config.mdes_version = ncs_config.pancakes_mdes_version
    end

    # Pancakes relies on many other services.
    #
    # Because we require connections to all of these services, we group them
    # into an object that we can easily scan.  Any blank value raises a fatal
    # error.
    config.services = {}

    # Use CAS for interactive authentication; permit HTTP Basic auth for
    # testing API endpoints.  In non-production environments, also permit test
    # logins.
    config.aker do
      if Pancakes.app_server?
        api_mode :http_basic
        portal :NCSNavigator
        ui_mode :cas
      end
    end
  end
end
