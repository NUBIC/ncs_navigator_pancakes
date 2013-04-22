require 'fileutils'
require 'foreman'
require 'foreman/engine/cli'
require 'json'

class ForemanEngine < Foreman::Engine::CLI
  include FileUtils

  attr_accessor :service_manifest_file
  attr_accessor :study_locations_file

  def service_manifest
    cas = process('cas')
    callback = process('callback')
    ops = process('ops')

    conf = {
      'CAS_BASE_URL' => "https://localhost:#{port_for(cas, 1)}/cas",
      'CAS_PROXY_CALLBACK_URL' => "https://localhost:#{port_for(callback, 1)}/receive_pgt",
      'CAS_PROXY_RETRIEVAL_URL' => "https://localhost:#{port_for(callback, 1)}/retrieve_pgt",
      'OPS_URL' => "http://localhost:#{port_for(ops, 1)}",
      'STUDY_LOCATIONS_PATH' => study_locations_file
    }

    conf.to_json
  end

  def shutdown
    super

    rm_f service_manifest_file if service_manifest_file
    rm_f study_locations_file if study_locations_file
  end

  def study_locations
    cases = process('cases')
    ports = (1..3).map { |n| port_for(cases, n) }

    { study_locations: [
        { name: "Foo",
          url: "http://localhost:#{ports[0]}"
        },
        { name: "Bar",
          url: "http://localhost:#{ports[1]}"
        },
        { name: "Baz",
          url: "http://localhost:#{ports[2]}"
        }
      ]
    }.to_json
  end
end
