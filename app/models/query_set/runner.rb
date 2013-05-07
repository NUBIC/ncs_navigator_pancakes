require 'celluloid'
require 'timeout'

module QuerySet
  ##
  # An Actor that runs code that is expected to occasionally fail.  If the
  # code fails, it is retried up to THRESHOLD times.
  #
  # The code ran MUST return an object that responds to #success?.  Success or
  # failure of the block is determined as follows:
  #
  # 1. If the block raises StandardError or a subclass, it fails.
  # 2. If the block times out, it fails.
  # 3. If #success? returns false, it fails.
  # 4. If #success? return true, it succeeds.
  #
  # If the code raises an exception whose class is not StandardError or a
  # subclass, it will NOT be caught.  The rationale is that non-StandardErrors
  # generally reflect errors that should result in termination of the Ruby
  # process, e.g. SyntaxErrors.
  #
  # Code objects will be retried a maximum of five times, and will time out
  # after 60 seconds.  Therefore, the maximum execution time for a given
  # object is 300 seconds.
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
    # code     - The object to run.  The object MUST have a zero-arity #call.
    # handlers - The result handlers.  See #run for more information.
    def self.queue(code, handlers)
      RunnerPool.future.run(code, handlers)
    end

    ##
    # Runs a query.
    #
    # A query may terminate in four ways:
    #
    # 1. Successfully.
    # 2. Non-exception failure.
    # 3. Exception failure.
    # 4. Timeout.
    #
    # These termination cases are handled by the success, failure, error, and
    # timeout handlers, respectively.  The success and non-exception failure
    # handlers receive the proc's return value.  The exception and timeout
    # handlers receive the exception object.
    #
    # There also exists a handler that is invoked whenever a query proc is
    # started.  This handler is given the query object.
    #
    # Example invocation:
    #
    #     run query,
    #       started: ->(obj) { ... },
    #       success: ->(ret) { ... },
    #       failure: ->(ret) { ... },
    #       error:   ->(err) { ... },
    #       timeout: ->(err) { ... }
    #
    # Each handler is passed the return value of the query proc.  You MUST
    # specify all handlers; a missing handler will raise an error.
    #
    # Returns the value of the invoked handler.
    def run(code, handlers)
      tries = 0

      loop do
        r = begin
              h(handlers, :started).call(code)
              ret = Timeout::timeout(TIMEOUT) { code.call }

              if ret.success?
                break h(handlers, :success).call(ret)
              else
                h(handlers, :failure).call(ret)
              end
            rescue Timeout::Error => e
              h(handlers, :timeout).call(e)
            rescue UnspecifiedHandlerError => e
              raise e
            rescue => e
              h(handlers, :error).call(e)
            end

        tries += 1

        if tries >= THRESHOLD
          break r
        end
      end
    end

    private

    def h(handlers, status)
      handlers[status] || lambda { |ret| raise UnspecifiedHandlerError, "#{status} handler not specified" }
    end
  end

  ##
  # Because most queries are HTTP requests, the size of this pool has a direct
  # influence on Pancakes' maximum number of concurrent outbound connections
  # to NCS Navigator services.
  RunnerPool = Runner.pool(:size => 16)

  class UnspecifiedHandlerError < StandardError
  end
end

# vim:ts=2:sw=2:et:tw=78
