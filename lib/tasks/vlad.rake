task 'vlad:deploy' => %w(
  vlad:update
  vlad:bundle:install
  vlad:assets:precompile
  vlad:migrate
  vlad:cleanup
)
