require 'spec_helper'

require File.expand_path('../../shared/models/an_active_model_object', __FILE__)

describe EventType do
  it_should_behave_like 'an ActiveModel object'

  describe '#to_json' do
    let(:code) { stub(:value => 1, :label => 'foo') }
    let(:json) { JSON.parse(EventType.new(code).to_json) }

    it 'maps local_code to "local_code"' do
      json['local_code'].should == 1
    end

    it 'maps local_code to "id"' do
      json['id'].should == 1
    end

    it 'maps display_text to "display_text"' do
      json['display_text'].should == 'foo'
    end
  end
end
