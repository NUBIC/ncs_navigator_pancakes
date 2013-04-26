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
end
