require 'spec_helper'

module QuerySet
  describe Status do
    let(:cache_key) { 'qs_test' }
    let(:redis) { $REDIS }
    let(:status) { Status.new(cache_key, redis) }

    before do
      redis.flushdb
    end

    describe 'if the query is not marked as started' do
      it 'is not started' do
        status.should_not be_started
      end
    end

    describe 'if the query is marked as started' do
      before do
        redis.sadd cache_key, StatusKeys::Started
      end

      it 'is started' do
        status.should be_started
      end
    end

    describe 'if the query is marked as done' do
      before do
        redis.sadd cache_key, StatusKeys::Done
      end

      it 'is done' do
        status.should be_done
      end
    end

    describe 'if the query is not marked as done' do
      it 'is not done' do
        status.should_not be_done
      end
    end

    describe '#to_json' do
      let(:json) { JSON.parse(status.to_json) }

      it 'includes #started?' do
        status.stub!(:started? => true)

        json['started'].should == true
      end

      it 'includes #done?' do
        status.stub!(:done? => true)

        json['done'].should == true
      end

      it "includes each query's status" do
        redis.sadd cache_key, 'qs_test_1'
        redis.hmset 'qs_test_1', 'tag', 'foo', 'status', 'bar'

        json['queries']['foo'].should == 'bar'
      end
    end
  end
end
