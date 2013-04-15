require 'celluloid/logger'
require 'ncs_navigator/authorization'

class DataCollectorStore
  include Celluloid

  def initialize
    @authority = NcsNavigator::Authorization::Core::Authority.new(
      :logger => Celluloid.logger,
      :staff_portal_uri => URI(Pancakes::Application.config.services[:ops])
    )
  end

  def request(*args)
    @f ||= Celluloid::Future.new do
      @authority.find_users(*args).freeze
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
