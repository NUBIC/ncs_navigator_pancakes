require 'sidekiq'

class EventSearchWorker
  include Sidekiq::Worker

  def perform(uuid, pgt, ttl)
    search = EventSearch.find(uuid)

    search.execute(pgt, ttl)
  end
end 
