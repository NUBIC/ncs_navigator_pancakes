require 'fileutils'
require 'foreman'
require 'foreman/engine/cli'
require 'json'

class ForemanEngine < Foreman::Engine::CLI
  include FileUtils

  attr_accessor :service_manifest_file

  def service_manifest
    cas = process('cas')
    callback = process('callback')
    ops = process('ops')

    conf = {
      'CAS_BASE_URL' => "https://localhost:#{port_for(cas, 1)}/cas",
      'CAS_PROXY_CALLBACK_URL' => "https://localhost:#{port_for(callback, 1)}/receive_pgt",
      'CAS_PROXY_RETRIEVAL_URL' => "https://localhost:#{port_for(callback, 1)}/retrieve_pgt",
      'OPS_URL' => "http://localhost:#{port_for(ops, 1)}"
    }

    conf.to_json
  end

  def shutdown
    super

    rm_f service_manifest_file if service_manifest_file
  end
end
