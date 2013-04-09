require 'ncs_navigator/mdes/specification'

class EventTypeStore
  include Celluloid

  def request(version = Pancakes::Application.config.mdes_version)
    @f ||= Celluloid::Future.new do
      spec = NcsNavigator::Mdes::Specification.new(version)
      cl = spec.types.detect { |t| t.name == 'event_type_cl1' }.code_list
      cl.map { |c| EventType.new(c) }.freeze
    end
  end

  def reload(*args)
    @f = nil
    request(*args)
  end

  def all
    request.value
  end
end
