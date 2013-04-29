class EventType < Model
  def self.all
    Stores.event_types.all
  end

  def initialize(code = nil)
    super

    @code = code
  end

  def valid?
    !!@code
  end

  def local_code
    @code.try(:value)
  end

  alias_method :id, :local_code

  def display_text
    @code.try(:label)
  end

  def attributes
    super.merge(local_code: local_code, display_text: display_text)
  end
end
