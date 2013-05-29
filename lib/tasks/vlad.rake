task 'vlad:load' do
  require 'vlad'
  require 'vlad/core'
  require 'bundler/vlad'
  require 'vlad/assets'
  require 'vlad/maintenance'
  require 'vlad/passenger'
  require 'vlad/rails'

  Vlad.load :scm => 'git'
end

task 'vlad:deploy' do
  Rake::Task['vlad:load'].invoke
  Rake::Task['vlad:continue_deploy'].invoke
end

task 'vlad:continue_deploy' => %w(
  vlad:update
  vlad:bundle:install
  vlad:assets:precompile
  vlad:migrate
  vlad:start_app
  vlad:cleanup
)
