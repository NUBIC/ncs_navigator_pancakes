##
# When users submit searches to Pancakes, the parameters of those searches are
# saved in an EventSearch instance.  After the instance is persisted to the
# database, the instance is passed to the search processors.
class EventSearch < ActiveRecord::Base
  serialize :json

  self.primary_key = :uuid

  # Public: Queues up this EventSearch for execution.
  #
  # pgt - a CAS proxy-granting ticket
  # ttl - lifetime of cached report data and metadata, in seconds
  #
  # Returns nothing.
  def queue(pgt, ttl)
    EventSearchWorker.perform_async(uuid, pgt, ttl)
  end

  def status
    EventReport.new(self, last_started_at).status
  end

  def data
    EventReport.new(self, last_started_at).data
  end

  # Public: Builds and executes an EventReport from this EventSearch.
  #
  # pgt - a CAS proxy-granting ticket
  # ttl - lifetime of cached report data and metadata, in seconds
  #
  # Returns an EventReport.
  def execute(pgt, ttl)
    started_at = Time.now

    update_attribute(:last_started_at, started_at)
    EventReport.new(self, started_at).tap { |r| r.execute(pgt, ttl) }
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
