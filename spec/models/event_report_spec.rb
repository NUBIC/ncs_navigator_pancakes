require 'spec_helper'

describe EventReport do
  let(:es) { EventSearch.new }
  let(:started_at) { Time.at(1234567890) }
  let(:report) { EventReport.new(es, started_at) }

  describe '#params' do
    let(:params) { report.params }

    it 'contains a list of event type codes in the EventSearch' do
      es.stub!(:event_type_ids => [1, 2, 3])

      params[:types].should == [1, 2, 3]
    end

    it 'contains NetIDs of data collectors' do
      es.stub!(:data_collector_netids => ['abc123'])

      params[:data_collectors].should == ['abc123']
    end

    it 'does not include empty NetID arrays' do
      es.stub!(:event_type_ids => [])

      params.should_not have_key(:types)
    end

    it 'includes [D,] for event searches with a start date D and no end date' do
      es.stub!(:scheduled_start_date => '2000-01-01', :scheduled_end_date => nil)

      params[:scheduled_date].should == '[2000-01-01,]'
    end

    it 'includes [,D] for event searches with no start date and end date D' do
      es.stub!(:scheduled_start_date => nil, :scheduled_end_date => '2000-01-01')

      params[:scheduled_date].should == '[,2000-01-01]'
    end

    it 'includes [D,E] for event searches with start date D and end date E' do
      es.stub!(:scheduled_start_date => '2000-01-01', :scheduled_end_date => '2000-02-01')

      params[:scheduled_date].should == '[2000-01-01,2000-02-01]'
    end
  end

  describe '#status' do
    before do
      $REDIS.flushdb
    end

    it 'maps :started to true when it is started' do
      report.execute(nil, 1.minute)

      report.status[:started].should be_true
    end

    it 'maps :started to false when it is not started' do
      report.status[:started].should be_false
    end

    it 'maps :done to true when it is done' do
      report.execute(nil, 1.minute)

      report.status[:done].should be_true
    end

    it 'maps :done to false when it is not done' do
      report.status[:done].should be_false
    end

    it "includes each query's status" do
      sl1 = StudyLocation.new('url' => 'https://cases1.example.edu')
      sl2 = StudyLocation.new('url' => 'https://cases2.example.edu')
      es.stub!(:locations => [sl1, sl2])

      report.execute(nil, 1.minute)

      report.status[:queries].keys.should include('https://cases1.example.edu')
      report.status[:queries].keys.should include('https://cases2.example.edu')
    end
  end

  shared_context 'event report data' do
    let(:sl) { StudyLocation.new('name' => 'Baz', 'url' => 'https://foo.example.edu') }
    let(:r1) do
      double(:body => { 'events' => [{ 'foo' => 'bar' }, { 'baz' => 'qux' }] },
             :location => sl)
    end

    before do
      $REDIS.flushdb
    end
  end

  describe '#collate' do
    include_context 'event report data'

    it 'inserts location data into each row' do
      report.collate([r1])

      report.data.should == [
        { 'foo' => 'bar', 'pancakes.location' => { 'name' => 'Baz', 'url' => 'https://foo.example.edu' } },
        { 'baz' => 'qux', 'pancakes.location' => { 'name' => 'Baz', 'url' => 'https://foo.example.edu' } }
      ]
    end
  end

  describe '#data' do
    include_context 'event report data'

    it 'is an empty list by default' do
      report.data.should == []
    end

    it 'is accessible to two EventReports with the same search and timecode' do
      report.collate([r1])
      report2 = EventReport.new(report.search, report.timecode)

      report2.data.should == report.data
    end
  end

  describe '#ttl' do
    describe 'if the report has data' do
      include_context 'event report data'

      it 'is the TTL set in execution' do
        report.execute('bogus', 3600)
        report.stub!(:collate => [])

        report.ttl.should be_within(10).of(3600)
      end
    end

    describe 'if the report has no data' do
      before do
        $REDIS.flushdb
      end

      it 'returns -1' do
        report.ttl.should == -1
      end
    end
  end
end
