require 'sidekiq'

class EventSearchWorker
  include Sidekiq::Worker

  def perform(uuid)
    search = EventSearch.find(uuid)
    search.execute
  end
end 
