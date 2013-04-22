require 'celluloid/logger'
require 'ncs_navigator/authorization'

class DataCollectorStore
  include Celluloid
  include Store

  def initialize
    @authority = NcsNavigator::Authorization::Core::Authority.new(
      :logger => Celluloid.logger,
      :staff_portal_uri => URI(Pancakes::Application.config.services[:ops]),
      :staff_portal_user => '',
      :staff_portal_password => ''
    )
  end

  def request
    @response ||= Celluloid::Future.new { @authority.find_users.freeze }
  end
end

# vim:ts=2:sw=2:et:tw=78
