##
# A StudyLocation represents a Cases instance.
class StudyLocation
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  attr_reader :name
  attr_reader :id
  attr_reader :errors

  def self.all
    Stores.study_locations.all
  end

  def initialize(config = {})
    @name = config['name']
    @id = config['id']
    @errors = ActiveModel::Errors.new(self)
  end

  alias_method :url, :id

  def valid?
    !!(name && id)
  end

  def new_record?
    !!id
  end
  
  def persisted?
    !new_record?
  end

  def attributes
    { name: name,
      id: id
    }
  end
  
  def as_json(*)
    attributes
  end
end
