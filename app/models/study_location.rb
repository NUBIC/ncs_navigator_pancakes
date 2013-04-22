##
# A StudyLocation represents a Cases instance.
class StudyLocation
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Serialization

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
