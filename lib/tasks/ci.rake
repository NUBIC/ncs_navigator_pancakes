# Disables db:test:prepare because our CI server doesn't like us deleting
# databases.

if Rails.env == 'ci'
  Rake::TaskManager.class_eval do
    def remove_task(name)
      @tasks.delete(name)
    end
  end

  Rake.application.remove_task 'db:test:prepare'

  namespace :db do
    namespace :test do
      task :prepare do
      end
    end
  end
end
