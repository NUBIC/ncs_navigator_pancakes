require 'ncs_navigator/configuration'
require 'thread'

module Pancakes::NcsNavigatorConfiguration
  Lock = Mutex.new

  def mdes_version=(v)
    Lock.synchronize { @mdes_version = v }
  end

  def mdes_version
    @mdes_version
  end

  def configure_from_ncs_navigator
    c = NcsNavigator::Configuration.new(config.navigator_ini_path)

    self.mdes_version = c.pancakes_mdes_version
  end
end
