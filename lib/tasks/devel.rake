require 'castanet/testing'
require 'shellwords'
require 'term/ansicolor'
require 'timeout'

require "#{Rails.root}/devel/foreman_engine"

scratch_dir = Rails.root.join('tmp', 'devel', 'servers')
server_dir = File.expand_path('../../../devel/servers', __FILE__)

desc 'Start services for development and test environments'
task :devenv do
  eng = ForemanEngine.new
  eng.service_manifest_file = "#{scratch_dir}/urls.#$$.json"
  eng.load_procfile(Rails.root.join('Procfile'))

  mkdir_p File.dirname(eng.service_manifest_file)
  File.open(eng.service_manifest_file, 'w') { |f| f.write(eng.service_manifest) }

  eng.start
end

Castanet::Testing::CallbackServerTasks.new(:scratch_dir => "#{scratch_dir}/callback")
Castanet::Testing::JasigServerTasks.new(:scratch_dir => "#{scratch_dir}/server",
                                        :jasig_url => 'https://download.nubic.northwestern.edu/ncs_navigator_pancakes/build_deps/cas-server-3.4.12-release.tar.gz',
                                        :jasig_checksum => 'd67466b0d3441b3a5817d1a918add6a0f598a3367ca595c33e6efcef5b170ab6',
                                        :jetty_url => 'https://download.nubic.northwestern.edu/ncs_navigator_pancakes/build_deps/jetty-distribution-8.1.7.v20120910.tar.gz')

namespace :devenv do
  task :clean do
    rm_rf scratch_dir
  end
end

namespace :test do
  desc 'Set services in the application environment'
  task :env do
    timeout = 120

    $stderr.puts <<-END
Looking for test infrastructure.  Will give up after #{timeout} seconds.

If you haven't done so already, run rake devenv in a separate shell or as a
background process.
    END

    Timeout::timeout(timeout) do
      loop do
        url_files = Dir["#{scratch_dir}/urls.*.json"]

        urls = url_files.first

        if url_files.length > 1
          $stderr.puts(Term::ANSIColor.yellow {
            %Q{
Multiple URL files were found:

#{url_files.join("\n")}

The URLs in #{urls} will be used.  This might contact nonexistent services,
which in turn may cause test failures.

This often indicates improper development environment shutdown occurred in
the past.  To eliminate this warning, remove all urls.* files under
#{scratch_dir} or run rake devenv:clean.
            }
          })
        end

        begin
          if urls
            $stderr.puts "Reading service configuration from #{urls}"

            json = JSON.parse(File.read(urls))
            json.each do |k, v|
              puts "export #{k}='#{v}'"
              ENV[k] = v
            end

            break
          else
            sleep 1
          end
        rescue JSON::ParserError
          # If we get this, we might have won a race with rake devenv.  Oops.
          # Just try again.
          puts "#{urls} contains invalid JSON, trying again"
          sleep 1
        end
      end
    end
  end

  namespace :ops do
    task :start => 'test:env' do
      exec "cd #{Shellwords.shellescape(server_dir)} && bundle exec ruby ops_mock.rb"
    end
  end
end

task :spec => ['test:env']
task :cucumber => ['test:env']
