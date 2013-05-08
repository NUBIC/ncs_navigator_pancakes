require 'logger'
require 'spec_helper'

describe QueryRunner do
  let(:r) { QueryRunner.new }

  after do
    begin
      r.terminate
    rescue Celluloid::DeadActorError
      # already dead? good, someone else did the dirty work
    end
  end

  let(:job) do
    Class.new do
      attr_accessor :retval
      attr_reader :tries, :error

      def initialize
        @tries = 0
      end

      def when_called(&block)
        @action = block
      end

      def call
        @tries += 1
        @action
        instance_eval(&@action) if @action
      end

      %w(started failed completed).each do |v|
        class_eval <<-END
          def #{v}; @#{v} = true; end
          def #{v}?; @#{v}; end
        END
      end

      alias_method :success?, :completed?

      def errored(e)
        @error = e
      end
    end.new
  end

  describe '#run' do
    describe 'when a job is started' do
      it 'invokes the started handler' do
        r.run(job)

        job.should be_started
      end
    end

    describe 'on success' do
      before do
        job.when_called { completed }
      end

      it 'returns the job' do
        r.run(job).should == job
      end

      it 'invokes the completed handler' do
        r.run(job)

        job.should be_completed
      end

      it 'stops running the job' do
        r.run(job)

        job.tries.should == 1
      end
    end

    describe 'on failure' do
      before do
        job.when_called { @success = false }
      end

      it 'retries a maximum of five times' do
        r.run(job)

        job.tries.should == 5
      end

      it 'invokes the failure handler' do
        r.run(job)

        job.should be_failed
      end
    end

    describe 'on timeout' do
      before do
        job.when_called { raise Timeout::Error, 'timed out' }
      end

      it 'retries a maximum of five times' do
        r.run(job)

        job.tries.should == 5
      end

      it 'invokes the error handler' do
        r.run(job)

        job.error.message.should == 'timed out'
      end
    end

    describe 'when an error is raised' do
      before do
        job.when_called { raise 'oops' }
      end

      it 'retries a maximum of five times' do
        r.run(job)

        job.tries.should == 5
      end

      it 'invokes the error handler' do
        r.run(job)

        job.error.message.should == 'oops'
      end
    end
  end

  describe '.queue' do
    it 'returns a future' do
      f = QueryRunner.queue(job)

      f.value.should == job
    end
  end
end
