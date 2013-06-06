require 'celluloid'
require 'timeout'

# Public: Caps the number of concurrent queries issued by Pancakes.
#
# Also provides retry and timeout guards.
class QueryRunner
  include Celluloid

  THRESHOLD = 5
  TIMEOUT = 60.seconds

  ##
  # Public: Queues up a job.
  def self.queue(job)
    QueryRunnerPool.future.run(job)
  end

  ##
  # Runs a query job.
  #
  # The job MUST respond as follows:
  #
  # *  #success?  - a boolean
  # *  #call      - zero arity
  # *  #started   - called when the job starts
  # *  #failed    - called when #success? is false
  # *  #completed - called when #success? is true
  # *  #errored   - called if #call raised an exception
  #
  # Job duration is limited to TIMEOUT seconds, and if they fail (i.e.
  # #success?  doesn't return truthy) will be retried THRESHOLD times.
  #
  # Returns the job.
  def run(job, &block)
    tries = 0

    loop do
      begin
        job.started
        Timeout::timeout(TIMEOUT) { job.call }

        if job.success?
          job.completed
          break job
        else
          job.failed
        end
      rescue Timeout::Error, StandardError => e
        job.errored(e)
      end

      tries += 1

      if tries >= THRESHOLD
        break job
      end
    end
  end
end

##
# Because most queries are HTTP requests, the size of this pool has a direct
# influence on Pancakes' maximum number of concurrent outbound connections
# to NCS Navigator services.
concurrency_level = ENV['QUERY_CONCURRENCY'] ? ENV['QUERY_CONCURRENCY'].to_i : 4
QueryRunnerPool = QueryRunner.pool(:size => concurrency_level)

# vim:ts=2:sw=2:et:tw=78
