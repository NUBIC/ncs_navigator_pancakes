class Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Serialization
 
  attr_reader :errors
  attr_reader :id

  def initialize(*)
    @errors = ActiveModel::Errors.new(self)
  end

  def valid?
    false
  end

  def new_record?
    !!id
  end

  def persisted?
    !new_record?
  end
  
  def attributes
    { id: id }
  end

  def as_json(*)
    attributes
  end
end
