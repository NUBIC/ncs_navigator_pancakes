##
# When users submit searches to Pancakes, the parameters of those searches are
# saved in an EventSearch instance.  After the instance is persisted to the
# database, the instance is passed to the search processors.
class EventSearch < ActiveRecord::Base
  serialize :json

  self.primary_key = :uuid

  ##
  # Queues processing of an EventSearch.
  def queue
    EventSearchWorker.perform_async(uuid)
  end

  def execute
  end
end

# vim:ts=2:sw=2:et:tw=78
