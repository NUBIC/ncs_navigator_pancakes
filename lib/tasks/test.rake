require 'castanet/testing'

scratch_dir = Rails.root.join('tmp', 'castanet-testing')

Castanet::Testing::CallbackServerTasks.new(:scratch_dir => "#{scratch_dir}/callback")
Castanet::Testing::JasigServerTasks.new(:scratch_dir => "#{scratch_dir}/server",
                                        :jasig_url => 'http://downloads.jasig.org/cas/cas-server-3.4.12-release.tar.gz',
                                        :jasig_checksum => 'd67466b0d3441b3a5817d1a918add6a0f598a3367ca595c33e6efcef5b170ab6')

namespace :test do
  namespace :dependencies do
    task :cas do
      loop do
        server_endpoint = Dir["#{scratch_dir}/server/**/.urls"].first
        callback_endpoints = Dir["#{scratch_dir}/callback/**/.urls"].first

        if server_endpoint && callback_endpoints
          data_s = JSON.parse(File.read(server_endpoint))
          data_c = JSON.parse(File.read(callback_endpoints))

          puts <<-END
export CAS_BASE_URL='#{data_s['url']}'
export CAS_PROXY_CALLBACK_URL='#{data_c['callback']}'
export CAS_PROXY_RETRIEVAL_URL='#{data_c['retrieval']}'
          END

          break
        else
          sleep 1
        end
      end
    end
  end
end
