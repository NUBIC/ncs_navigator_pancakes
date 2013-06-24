require 'pancakes/config'

if ENV['REDIS_URL']
  Pancakes::Config.from_env :redis, { url: ENV['REDIS_URL'], namespace: 'nubic:pancakes' }
end

if ENV['OPS_URL']
  Pancakes::Config.from_env :ops, ENV['OPS_URL']
end

if ENV['STUDY_LOCATIONS_PATH']
  Pancakes::Config.from_env :study_locations_file, ENV['STUDY_LOCATIONS_PATH']
end

if %w(CAS_BASE_URL CAS_PROXY_CALLBACK_URL CAS_PROXY_RETRIEVAL_URL).all? { |e| ENV[e] }
  Pancakes::Config.from_env :cas, {
    base_url: ENV['CAS_BASE_URL'],
    proxy_callback_url: ENV['CAS_PROXY_CALLBACK_URL'],
    proxy_retrieval_url: ENV['CAS_PROXY_RETRIEVAL_URL']
  }

  Pancakes::Application.config.aker do
    ui_mode :cas
    cas_parameters Pancakes::Config[:cas]

    if Rails.env.production?
      authorities :cas, :automatic_access
    else
      static = Aker::Authorities::Static.from_file(File.expand_path('../../../devel/logins.yml', __FILE__))
      authorities :cas, static
    end
  end
end
