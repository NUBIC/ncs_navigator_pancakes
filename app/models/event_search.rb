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

  ##
  # Runs this search against all study locations configured in the search.
  #
  # Requires a CAS PGT as a string.
  def execute(pgt)
    locations.each { |sl| sl.events_for(self, pgt) }
  end

  def event_type_ids
    a('event_types').map { |et| et['local_code'] }
  end

  def data_collector_netids
    a('data_collectors').map { |dc| dc['username'] }
  end

  def locations
    a('study_locations').map { |sl| StudyLocation.new(sl) }
  end

  def scheduled_start_date
    v('scheduled_start_date')
  end

  def scheduled_end_date
    v('scheduled_end_date')
  end

  private

  def a(key)
    v(key) || []
  end

  def v(key)
    json.try(:[], key)
  end
end

# vim:ts=2:sw=2:et:tw=78
