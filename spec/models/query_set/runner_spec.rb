require 'logger'
require 'spec_helper'

module QuerySet
  describe Runner do
    let(:r) { Runner.new }

    after do
      begin
        r.terminate
      rescue Celluloid::DeadActorError
        # already dead? good, someone else did the dirty work
      end
    end

    describe '#run' do
      attr_reader :tries, :started

      def try; @tries += 1; end
      def start; @started = true; end

      def run
        r.run query,
          started: ->(obj) { start },
          success: ->(ret) { try; [ret, :ran_success] },
          failure: ->(ret) { try; [ret, :ran_failure] },
          error:   ->(err) { try; [err.message, :ran_error] },
          timeout: ->(err) { try; [err.message, :ran_timeout] }
      end
      
      before do
        @tries = 0
        @started = false
      end
      
      describe 'when a code object is started' do
        let(:query) { ->{ double(:success? => true) } }

        it 'invokes the started handler' do
          run

          started.should be_true
        end
      end

      describe 'on success' do
        let(:result) { double(:success? => true) }
        let(:query) { ->{ result } }

        it 'invokes the success handler' do
          run.should == [result, :ran_success]
        end
        
        it 'stops running the code object' do
          run

          tries.should == 1
        end
      end

      describe 'on failure' do
        let(:result) { double(:success? => false) }
        let(:query) { ->{ result } }

        it 'retries a maximum of five times' do
          run

          tries.should == 5
        end

        it 'invokes the failure handler' do
          run.should == [result, :ran_failure]
        end
      end

      describe 'on timeout' do
        let(:query) do
          lambda { raise Timeout::Error, 'timed out' }
        end

        it 'retries a maximum of five times' do
          run

          tries.should == 5
        end

        it 'invokes the timeout handler' do
          run.should == ['timed out', :ran_timeout]
        end
      end

      describe 'when an error is raised' do
        let(:query) do
          lambda { raise 'oops' }
        end

        it 'retries a maximum of five times' do
          run

          tries.should == 5
        end

        it 'invokes the error handler' do
          run.should == ['oops', :ran_error]
        end
      end

      describe 'if a handler is invoked but not specified' do
        let(:result) { double(:success? => true) }
        let(:query) { ->{ result } }

        # Celluloid logs exception messages to its logger.  This is handy for
        # production, but not really that useful for this example.
        around do |example|
          begin
            old_logger = Celluloid.logger
            Celluloid.logger = nil
            example.call
          ensure
            Celluloid.logger = old_logger
          end
        end

        it 'raises UnspecifiedHandlerError' do
          lambda { r.run(query, {}) }.should raise_error(UnspecifiedHandlerError)
        end
      end
    end

    describe '.queue' do
      let(:query) { ->{ double(:success? => true) } }

      it 'returns a future' do
        future = Runner.queue query, started: ->(obj) { }, success: ->(ret) { :done }

        future.value.should == :done
      end
    end
  end
end
