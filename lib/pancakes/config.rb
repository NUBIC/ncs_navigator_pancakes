module Pancakes
  module Config
    module_function

    def from_env(key, value)
      Rails.logger.info "Setting #{key} from environment"
      set_config key, value
    end

    def from_file(key, value)
      Rails.logger.info "Setting #{key} from file"
      set_config key, value
    end

    def [](key)
      Pancakes::Application.config.services[key]
    end

    def set_config(key, value)
      Pancakes::Application.config.services[key] = value
    end
  end
end

