require 'ncs_navigator/mdes/specification'

class EventTypeStore
  def load(version = Pancakes::Application.mdes_version)
    spec = NcsNavigator::Mdes::Specification.new(version)
    cl = spec.types.detect { |t| t.name == 'event_type_cl1' }.code_list

    @cache = cl.map { |c| EventType.new(c) }
  end

  def all
    @cache
  end
end
