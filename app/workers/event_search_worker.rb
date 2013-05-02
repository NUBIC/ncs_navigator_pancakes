require 'sidekiq'

class EventSearchWorker
  include Sidekiq::Worker

  def perform(uuid, pgt)
    search = EventSearch.find(uuid)

    search.execute(pgt)
  end
end 
