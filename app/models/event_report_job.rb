class EventReportJob
  Status = 'status'
  Tag = 'tag'
  Error = 'error'

  attr_reader :response, :verified
  attr_reader :cache_key, :location, :params, :pgt

  def initialize(location, params, pgt, cache_key)
    @location = location
    @params = params
    @pgt = pgt
    @cache_key = cache_key
  end

  def call
    @response = location.events(params, pgt)

    verify if response.success?
  end

  def body
    response.body
  end

  def success?
    response.try(:success?) && verified
  end

  def started
    cache :started
  end

  def failed
    cache :failure
  end

  def completed
    cache :success
  end

  def errored(e)
    cache :error, { message: e.message, backtrace: e.backtrace }.to_json
  end

  private

  def verify
    @verified = true
  end

  def cache(status, error = nil)
    key = "#{cache_key}:#{location.id}"
    redis.sadd cache_key, key

    if error
      redis.hmset key, Tag, location.id, Status, status, Error, error
    else
      redis.hmset key, Tag, location.id, Status, status
    end
  end

  def redis
    $REDIS
  end
end
