set :application, 'ncs_navigator_pancakes'
set :deploy_to, ENV['DEPLOY_TO']
set :keep_releases, 5
set :repository, 'https://github.com/NUBIC/ncs_navigator_pancakes.git'
set :revision, ENV['REVISION'] || 'origin/master'

set :user, ENV['USER'] || 'ncs_navigator_pancakes'
set :domain, user + '@' + ENV['DOMAIN']
