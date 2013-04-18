require 'ncs_navigator/mdes/specification'

class EventTypeStore
  include Celluloid
  include Store

  def request
    @response ||= Celluloid::Future.new do
      version = Pancakes::Application.config.mdes_version
      spec = NcsNavigator::Mdes::Specification.new(version)
      cl = spec.types.detect { |t| t.name == 'event_type_cl1' }.code_list
      cl.map { |c| EventType.new(c) }.freeze
    end
  end
end
