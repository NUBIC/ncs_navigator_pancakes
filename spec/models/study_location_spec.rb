require 'spec_helper'

require File.expand_path('../../shared/models/an_active_model_object', __FILE__)

describe StudyLocation do
  it_should_behave_like 'an ActiveModel object'

  let(:model) do
    StudyLocation.new('name' => 'Foobar', 'url' => 'https://cases.example.edu')
  end

  describe '#to_json' do
    let(:json) { JSON.parse(model.to_json) }

    it 'maps name to "name"' do
      json['name'].should == "Foobar"
    end

    it 'maps url to "url"' do
      json['url'].should == "https://cases.example.edu"
    end
  end

  describe '#params_for' do
    let(:es) { EventSearch.new }
    let(:params) { model.params_for(es) }

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
