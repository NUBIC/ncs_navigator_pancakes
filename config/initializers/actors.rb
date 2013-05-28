# Threads are not copied across forks, so we need to start webapp process
# actors in each forked process.
#
# This doesn't apply to Sidekiq workers.
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    Stores.run!
    Stores.reload
  end
else
  if Pancakes.app_server?
    Stores.run!
    Stores.reload
  end
end
