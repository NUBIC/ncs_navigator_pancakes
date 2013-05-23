if Pancakes.app_server?
  Stores.run!
  Stores.reload
end
