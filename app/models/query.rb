require 'celluloid'
require 'timeout'

##
# An Actor that runs a proc (typically a query) that is expected to
# occasionally fail.  If the proc fails, it is retried up to THRESHOLD times.
#
# Procs MUST return an object that responds to #success?.  Success or
# failure of the block is determined as follows:
#
# 1. If the block raises an exception, it fails.
# 2. If the block times out, it fails.
# 3. If #success? returns false, it fails.
# 4. If #success? return true, it succeeds.
#
# Procs will be retried a maximum of five times, and will time out after 60
# seconds.  Therefore, the maximum execution time for a given proc is 300
# seconds.
#
# It is RECOMMENDED that you call Query.queue to queue up work.  Query.queue
# will return a Celluloid::Future, which on completion will yield an object
# that responds to the following messages:
#
# - #status: one of :success, :failure, :timeout, or :exception
# - #value: if #status is :timeout or :exception, the exception; otherwise,
#   the value returned from the proc
# - #extra: any extra metadata you passed into .queue
class Query
  include Celluloid

  THRESHOLD = 5
  TIMEOUT = 60.seconds

  def self.queue(code, *extra)
    QueryPool.future.run(code, *extra)
  end

  def run(code, *extra)
    tries = 0

    loop do
      r = begin
            ret = Timeout::timeout(TIMEOUT) { code.call }

            if ret.success?
              Result.new(:success, ret, extra)
            else
              Result.new(:failure, ret, extra)
            end
          rescue Timeout::Error => e
            Result.new(:timeout, e, extra)
          rescue => e
            Result.new(:exception, e, extra)
          end

      tries += 1

      if r.first == :success || tries > THRESHOLD
        break r
      end
    end
  end

  class Result < Struct.new(:status, :value, :extra)
  end
end

##
# Because most queries are HTTP requests, the size of this pool has a direct
# influence on Pancakes' maximum number of concurrent outbound connections to
# NCS Navigator services.
QueryPool = Query.pool(:size => 16)

# vim:ts=2:sw=2:et:tw=78
