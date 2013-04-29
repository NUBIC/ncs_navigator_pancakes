require 'celluloid/logger'
require 'ncs_navigator/authorization'

class DataCollectorStore
  include Celluloid
  include Store

  def initialize
    @authority = NcsNavigator::Authorization::Core::Authority.new(
      :logger => Celluloid.logger,
      :staff_portal_uri => URI(Pancakes::Application.config.services[:ops]),
      :staff_portal_password => staff_portal_password
    )
  end

  def staff_portal_password
    Pancakes::Application.config.ncs_config.staff_portal['psc_user_password']
  end

  def request
    @response ||= Celluloid::Future.new do
      users = @authority.find_users
      users.map { |u| DataCollector.new(u) }.freeze
    end
  end
end

# vim:ts=2:sw=2:et:tw=78
