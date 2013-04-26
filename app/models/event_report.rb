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
# EventReport data is cached for one hour.
class EventReport
  attr_reader :search

  ##
  # es - The EventSearch that will be used to generate this report's data.
  def initialize(es)
    @search = es
  end

  # Public: Build the report.
  #
  # The report data, once assembled, will be available via the #data reader.
  # See that method's documentation for more information.
  #
  # pgt - a CAS PGT that will be used to contact each Cases instance named in
  #       the EventSearch.
  #
  # Returns nothing.
  def execute(pgt)
    qs = search.locations.map do |l|
      ::Query.queue run_at_location(l, pgt), l
    end

    qs.map(&:value)
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
