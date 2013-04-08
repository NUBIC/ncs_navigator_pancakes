require 'spec_helper'

require 'active_model/lint'

shared_examples_for 'an ActiveModel object' do
  include ActiveModel::Lint::Tests

  let(:model) { subject }

  ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |m|
    example m.gsub('_',' ') do
      send m
    end
  end
end
