# Disables db:test:prepare because our CI server doesn't like us deleting
# databases.
namespace :db do
  namespace :test do
    task :prepare do
    end
  end
end
