namespace :ember do
  EMBER_DATA = 'vendor/ember-data'

  namespace :data do
    desc 'Rebuild and install Ember Data'
    task :install => [:ensure, :build] do
      mkdir_p "vendor/assets/javascripts/ember-data-git"
      cp "#{EMBER_DATA}/dist/ember-data.js", "vendor/assets/javascripts/ember-data-git"
    end

    task :ensure do
      abort 'ember-data submodule is missing' unless File.exists?("#{EMBER_DATA}/Rakefile")
    end

    task :build do
      Bundler.with_clean_env do
        cd EMBER_DATA do
          sh 'bundle install && bundle exec rake dist'
        end
      end
    end
  end
end
