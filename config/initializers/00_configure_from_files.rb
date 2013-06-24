require 'pancakes/config'

if ENV['USE_BCDATABASE_FOR_REDIS']
  db_config = File.read(Rails.root.join("config/database.yml"))
  redis_conf = YAML.load(ERB.new(db_config).result(binding))["redis_#{Rails.env}"]

  if !redis_conf
    fail "No Redis configuration found for #{Rails.env}"
  end

  redis_url = "redis://#{redis_conf['host']}:#{redis_conf['port']}/#{redis_conf['db']}"
  Pancakes::Config.from_file :redis, { url: redis_url, namespace: 'nubic:pancakes' }
end

if ENV['AKER_CENTRAL_PATH']
  Pancakes::Application.config.aker do
    ui_mode :cas
    central ENV['AKER_CENTRAL_PATH']

    if Rails.env.production?
      authorities :cas
    else
      static = Aker::Authorities::Static.from_file(File.expand_path('../../../devel/logins.yml', __FILE__))
      authorities :cas, static
    end
  end
end
