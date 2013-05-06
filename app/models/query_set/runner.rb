require 'celluloid'
require 'timeout'

module QuerySet
  ##
  # An Actor that runs a proc (typically a query) that is expected to
  # occasionally fail.  If the proc fails, it is retried up to THRESHOLD
  # times.
  #
  # Procs MUST return an object that responds to #success?.  Success or
  # failure of the block is determined as follows:
  #
  # 1. If the block raises StandardError or a subclass, it fails.
  # 2. If the block times out, it fails.
  # 3. If #success? returns false, it fails.
  # 4. If #success? return true, it succeeds.
  #
  # If a Proc raises an exception whose class is not StandardError or a
  # subclass, it will NOT be caught.  The rationale is that non-StandardErrors
  # generally reflect errors that should result in termination of the Ruby
  # process, e.g. SyntaxErrors.
  #
  # Some libraries do not respect this convention.  In those cases, you will
  # have to rescue the offending exception yourself or get in touch with the
  # library's author to fix things up.
  #
  # Procs will be retried a maximum of five times, and will time out after 60
  # seconds.  Therefore, the maximum execution time for a given proc is 300
  # seconds.
  #
  # It is RECOMMENDED that you call Runner.queue to queue up work.
  # Runner.queue will return a Celluloid::Future, which on completion will
  # yield an object of your choice.
  class Runner
    include Celluloid

    THRESHOLD = 5
    TIMEOUT = 60.seconds

    ##
    # Public: Queues up a query proc for execution.
    #
    # code     - The proc to run.  The proc MUST have zero arity.
    # tag      - An object associated with this proc.  Used by the reporter to
    #            label the proc's result.
    # reporter - Query results are sent here.  See #run for the expected
    #            interface.
    def self.queue(code, tag, reporter)
      RunnerPool.future.run(code, tag, reporter)
    end

    ##
    # Runs a query.
    #
    # When a query proc terminates or times out, its return value (or
    # associated exception) and tag are sent to the reporter.  The reporter
    # MUST respond to the following messages:
    #
    # 1. #started(tag):      called when the query proc begins execution
    # 2. #success(ret, tag): called if the proc's return value responds truthy
    #                        to #success?
    # 3. #failure(ret, tag): called if the proc's return value responds falsy
    #                        to #success?
    # 4. #timeout(ret, tag): called if the proc timed out
    # 5. #error(ret, tag):   called if the proc raised StandardError or
    #                        subclass
    def run(code, tag, reporter)
      tries = 0

      loop do
        r = begin
              reporter.started(tag)
              ret = Timeout::timeout(TIMEOUT) { code.call }

              if ret.success?
                break reporter.success(ret, tag)
              else
                reporter.failure(ret, tag)
              end
            rescue Timeout::Error => e
              reporter.timeout(e, tag)
            rescue => e
              reporter.error(e, tag)
            end

        tries += 1

        if tries > THRESHOLD
          break r
        end
      end
    end
  end

  ##
  # Because most queries are HTTP requests, the size of this pool has a direct
  # influence on Pancakes' maximum number of concurrent outbound connections
  # to NCS Navigator services.
  RunnerPool = Runner.pool(:size => 16)
end

# vim:ts=2:sw=2:et:tw=78
