# Disables db:test:prepare because our CI server doesn't like us deleting
# databases.

if Rails.env == 'ci'
  namespace :db do
    namespace :test do
      task :purge do
      end
    end
  end
end
