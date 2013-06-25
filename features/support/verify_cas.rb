require 'castanet/testing'
require 'castanet/testing/connection_testing'
require 'timeout'

Cucumber::Rails::World.send(:include, Castanet::Testing::ConnectionTesting)

Before do
  [cas_base_url, cas_proxy_callback_url].each do |url|
    Timeout::timeout(60) do
      loop do
        if responding?(url)
          break
        else
          sleep 1
        end
      end
    end
  end
end
