module QuerySet
  ##
  # Internal: Interprets query set statuses stored in Redis.
  class Status
    include StatusKeys

    attr_reader :key
    attr_reader :redis

    attr_reader :started, :done, :queries

    alias_method :started?, :started
    alias_method :done?, :done

    def initialize(key, redis)
      @key = key
      @redis = redis

      read
    end

    def as_json(*)
      { started: started?,
        done: done?,
        queries: queries
      }
    end

    private

    def read
      keys = redis.smembers(key)
      results = []

      redis.pipelined do
        keys.each do |k|
          if !(k == Done || k == Started)
            results << redis.hmget(k, Tag, StatusKeys::Status)
          end
        end
      end

      @queries = Hash[*results.map(&:value).flatten]
      @started = keys.include?(Started)
      @done = keys.include?(Done)
    end
  end
end
