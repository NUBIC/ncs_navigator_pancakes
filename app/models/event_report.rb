##
# An EventReport is the result of executing an EventSearch.
#
# EventReports have five components:
#
# 1. The EventSearch from which they spawned
# 2. When they began execution (from 1)
# 3. Their report criteria (also from 1)
# 4. Execution status
# 5. The report data
#
# Report data and metadata is cached in Redis to speed up retrieval and
# pagination.
class EventReport
  attr_reader :search
  attr_reader :started_at

  ##
  # es         - The EventSearch that will be used to generate this report's
  #              data.
  # started_at - When report generation started.
  def initialize(es, started_at)
    @search = es
    @started_at = started_at.to_i
  end

  def cache_key
    "report:#{search.id}:#{started_at}"
  end

  # Public: Build the report.
  #
  # The report data, once assembled, will be available via the #data reader.
  # See that method's documentation for more information.
  #
  # pgt - a CAS PGT that will be used to contact each Cases instance
  #       named in the EventSearch
  # ttl - lifetime of cached report data and metadata, in seconds
  #
  # Returns nothing.
  def execute(pgt, ttl)
    recorder = QuerySet::Recorder.new(self, ttl, $REDIS)

    qs = search.locations.map do |l|
      QuerySet::Runner.queue run_at_location(l, pgt), l.id, recorder
    end

    qs.map(&:value).tap { |v| recorder.alldone }
  end

  def status
    QuerySet::Status.new(cache_key, $REDIS)
  end

  # Public: Translates this report's EventSearch into API parameters.
  def params
    { types: search.event_type_ids,
      data_collectors: search.data_collector_netids,
      scheduled_date: date_range
    }.reject { |_, v| v.blank? }
  end

  private

  def run_at_location(l, pgt)
    lambda { l.connection(pgt) { |c| c.get('/api/v1/events', params) } }
  end

  def date_range
    "[#{[search.scheduled_start_date, search.scheduled_end_date].join(',')}]"
  end
end

# vim:ts=2:sw=2:et:tw=78
