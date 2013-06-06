# Public: The result of executing an EventSearch.
class EventReport
  Done = '__done__'
  Started = '__started__'
  Status = 'status'
  Tag = 'tag'

  attr_reader :search
  attr_reader :started_at

  ##
  # search     - The EventSearch that will be used to generate this report's
  #              data.
  # started_at - When report generation started.
  def initialize(search, started_at)
    @search = search
    @started_at = started_at.to_i
  end

  def cache_key
    "report:#{search.id}:#{started_at}"
  end

  # Public: Build the report.
  #
  # pgt - a CAS PGT that will be used to contact each Cases instance
  #       named in the EventSearch
  # ttl - lifetime of cached report data and metadata, in seconds
  #
  # Returns nothing.
  def execute(pgt, ttl)
    startall

    locations = search.locations.each(&:freeze)
    jobs = locations.map { |l| EventReportJob.new(l, params, pgt, cache_key) }
    futures = jobs.map { |job| QueryRunner.queue(job) }
    results = futures.map(&:value)

    collate results.select(&:success?)
    doneall(ttl)
  end

  # Public: The TTL of the data key.
  #
  # Returns the TTL of the data key, or -1 if the data does not exist or has
  #   expired.
  def ttl
    $REDIS.ttl(data_list_key)
  end

  def status
    read_status

    { started: @started,
      done: @done,
      queries: @query_statuses
    }
  end

  # Public: Translates this report's EventSearch into API parameters.
  def params
    { types: search.event_type_ids,
      data_collectors: search.data_collector_netids,
      scheduled_date: date_range
    }.reject { |_, v| v.blank? }
  end

  # Public: This report's data.
  #
  # Data, like all other EventReport characteristics, is identified by a
  # search ID and a start timestamp.  Therefore, two EventReports with the
  # same search ID and started_at will have the same data.
  def data
    data = redis.get(data_list_key)
    data ? JSON.parse(data) : []
  end

  # Internal: Collates results from #execute.
  #
  # This method is intended for use only by EventReport, but is publicly
  # exposed for testing.
  #
  # Returns nothing.
  def collate(results)
    agg = results.each_with_object([]) do |result, r|
      next unless result.body.respond_to?('has_key?') && result.body.has_key?('events')

      name = result.location.name
      url = result.location.url

      result.body['events'].each do |e|
        e['pancakes.location'] = { 'name' => name, 'url' => url }
        r << e
      end
    end

    record(data_list_key) { |k| redis.set k, agg.to_json }
  end

  private

  def data_list_key
    "#{cache_key}:data"
  end

  def startall
    record Started
  end

  def doneall(ttl)
    keys = redis.smembers cache_key
    time = Time.now.to_i + ttl

    redis.multi do
      record Done
      keys.each { |k| redis.expireat k, time }
      redis.expireat cache_key, time
    end
  end

  def read_status
    keys = redis.smembers cache_key
    results = []

    redis.pipelined do
      keys.each do |k|
        if !(k == Done || k == Started || k == data_list_key)
          results << redis.hmget(k, Tag, Status)
        end
      end
    end

    @query_statuses = Hash[*results.map(&:value).flatten]
    @started = keys.include?(Started)
    @done = keys.include?(Done)
  end

  def date_range
    "[#{[search.scheduled_start_date, search.scheduled_end_date].join(',')}]"
  end

  def record(key)
    redis.sadd cache_key, key
    yield key if block_given?
  end

  def redis
    $REDIS
  end
end

# vim:ts=2:sw=2:et:tw=78
