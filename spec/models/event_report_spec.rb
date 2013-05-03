require 'spec_helper'

describe EventReport do
  describe '#params' do
    let(:es) { EventSearch.new }
    let(:started_at) { Time.at(1234567890) }
    let(:er) { EventReport.new(es, started_at) }
    let(:params) { er.params }

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
end
