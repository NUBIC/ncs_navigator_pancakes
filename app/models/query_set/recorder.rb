require 'json'

module QuerySet
  ##
  # Public: Records information about query runs in Redis.
  #
  # "Information" consists of the query return value as well as the following
  # metadata:
  #
  # - the query tag as a string
  # - the ID of the owner that generated the query
  # - when the recorded data will expire
  # - the ultimate outcome of each query (success, failure, timeout, error)
  class Recorder
    include StatusKeys

    attr_reader :ttl
    attr_reader :owner
    attr_reader :r

    ##
    # owner - the owner of all queries that this recorder will record.  This
    #         MUST respond to #cache_key.
    # ttl   - lifetime of cached report data and metadata, in seconds
    # redis - a Redis client
    def initialize(owner, ttl, redis)
      @ttl = ttl
      @owner = owner
      @r = redis
    end

    def started(tag)
      result 'started', tag
    end

    def success(ret, tag)
      result 'success', tag, present_resp(ret)
    end

    def failure(ret, tag)
      result 'failure', tag, present_resp(ret)
    end

    def timeout(err, tag)
      result 'timeout', tag, present_error(err)
    end

    def error(err, tag)
      result 'error', tag, present_error(err)
    end

    def alldone
      keys = r.smembers owner.cache_key
      time = Time.now.to_i + ttl

      r.multi do
        r.sadd owner.cache_key, Done
        keys.each { |k| r.expireat k, time }
        r.expireat owner.cache_key, time
      end
    end

    private

    def result(status, tag, data = {})
      key = "#{owner.cache_key}:#{tag}"
      r.sadd owner.cache_key, key
      r.hmset key, Tag, tag, StatusKeys::Status, status, Data, data.to_json
    end

    def present_resp(resp)
      { body: resp.body, status: resp.status }
    end

    def present_error(err)
      { message: err.message, backtrace: err.backtrace }
    end
  end
end

# vim:ts=2:sw=2:et:tw=78
