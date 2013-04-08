class EventType
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  attr_reader :errors

  def self.all
    EventTypeStore.new.tap(&:load).all
  end

  def initialize(code = nil)
    @code = code
    @errors = ActiveModel::Errors.new(self)
  end

  def valid?
    !!@code
  end

  def new_record?
    !!@code
  end

  def persisted?
    !new_record?
  end

  def local_code
    @code.try(:value)
  end

  alias_method :id, :local_code

  def display_text
    @code.try(:label)
  end

  def attributes
    {
      local_code: local_code,
      display_text: display_text,
      id: id
    }
  end
  
  def as_json(*)
    attributes
  end
end
