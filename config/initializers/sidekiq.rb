if Pancakes::Application.config.services[:redis]
  c = { :url => Pancakes::Application.config.services[:redis][:url],
        :namespace => Pancakes::Application.config.services[:redis][:namespace] + ":sidekiq"
      }

  Sidekiq.configure_client { |client| client.redis = c }
  Sidekiq.configure_server { |server| server.redis = c }
else
  Rails.logger.warn "Redis configuration not found; not configuring Sidekiq"
end
