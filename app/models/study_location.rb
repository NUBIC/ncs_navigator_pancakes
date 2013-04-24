require 'pancakes/cas_https_client'

##
# A StudyLocation represents a Cases instance.
class StudyLocation
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include Pancakes::CasHttpsClient

  attr_reader :name
  attr_reader :url
  attr_reader :errors

  def self.all
    Stores.study_locations.all
  end

  def initialize(config = {})
    @name = config['name']
    @url = config['url']
    @errors = ActiveModel::Errors.new(self)
  end

  ##
  # Runs an event search against this location.  Returns a Faraday::Response.
  #
  # - es: an EventSearch object
  # - pgt: a CAS proxy-granting ticket
  def events_for(es, pgt)
    client(:url => url, :pgt => pgt).get('/api/v1/events', params_for(es))
  end

  def params_for(es)
    { types: es.event_type_ids,
      data_collectors: es.data_collector_netids,
      scheduled_date: date_range_for(es)
    }.reject { |_, v| v.blank? }
  end

  def date_range_for(es)
    "[#{[es.scheduled_start_date, es.scheduled_end_date].join(',')}]"
  end

  def valid?
    !!(name && url)
  end

  def new_record?
    !!url
  end

  def persisted?
    !new_record?
  end

  def attributes
    { name: name,
      url: url
    }
  end

  def as_json(*)
    attributes
  end
end
