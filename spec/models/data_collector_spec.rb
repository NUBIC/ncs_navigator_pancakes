require 'aker'
require 'spec_helper'

require File.expand_path('../../shared/models/an_active_model_object', __FILE__)

describe DataCollector do
  it_should_behave_like 'an ActiveModel object'

  describe '#to_json' do
    let(:user) do
      Aker::User.new('abc123').tap do |u|
        u.first_name = 'A'
        u.last_name = 'C'
      end
    end

    let(:json) { JSON.parse(DataCollector.new(user).to_json) }

    it 'maps username to "id"' do
      json['id'].should == 'abc123'
    end

    it 'maps first_name to "first_name"' do
      json['first_name'].should == 'A'
    end

    it 'maps last_name to "last_name"' do
      json['last_name'].should == 'C'
    end
  end
end
