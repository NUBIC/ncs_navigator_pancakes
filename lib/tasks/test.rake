require 'castanet/testing'
require 'term/ansicolor'
require 'timeout'

scratch_dir = Rails.root.join('tmp', 'devel', 'servers')

Castanet::Testing::CallbackServerTasks.new(:scratch_dir => "#{scratch_dir}/callback")
Castanet::Testing::JasigServerTasks.new(:scratch_dir => "#{scratch_dir}/server",
                                        :jasig_url => 'https://download.nubic.northwestern.edu/ncs_navigator_pancakes/build_deps/cas-server-3.4.12-release.tar.gz',
                                        :jasig_checksum => 'd67466b0d3441b3a5817d1a918add6a0f598a3367ca595c33e6efcef5b170ab6',
                                        :jetty_url => 'https://download.nubic.northwestern.edu/ncs_navigator_pancakes/build_deps/jetty-distribution-8.1.7.v20120910.tar.gz')

namespace :test do
  desc 'Set up process environment for tests'
  task :env do
    timeout = 120

    $stderr.puts <<-END
Looking for test infrastructure.  Will give up after #{timeout} seconds.

If you haven't done so already, run foreman start in a separate shell or as a
background process.
    END

    Timeout::timeout(timeout) do
      Rake::Task['test:env:cas'].invoke
      Rake::Task['test:env:ops'].invoke
    end
  end

  namespace :env do
    task :cas do
      loop do
        server_urls = Dir["#{scratch_dir}/server/**/.urls"]
        callback_urls = Dir["#{scratch_dir}/callback/**/.urls"]

        w_cas ||= warn_if_multiple 'CAS server', server_urls, scratch_dir
        w_cb ||= warn_if_multiple 'proxy callback', callback_urls, scratch_dir

        if !server_urls.empty? && !callback_urls.empty?
          data_s = JSON.parse(File.read(server_urls.first))
          data_c = JSON.parse(File.read(callback_urls.first))

          set_env('CAS_BASE_URL', data_s['url'])
          set_env('CAS_PROXY_CALLBACK_URL', data_c['callback'])
          set_env('CAS_PROXY_RETRIEVAL_URL', data_c['retrieval'])

          break
        else
          sleep 1
        end
      end
    end

    task :ops do
      loop do
        ops_urls = Dir["#{scratch_dir}/ops_mock/**/.urls"]

        w ||= warn_if_multiple 'Ops', ops_urls, scratch_dir

        if !ops_urls.empty?
          url = JSON.parse(File.read(ops_urls.first))['url']

          set_env('OPS_URL', url)
          break
        else
          sleep 1
        end
      end
    end

    def warn_if_multiple(entity, values, scratch_dir)
      if values.length > 1
        $stderr.puts(Term::ANSIColor::yellow {
          %Q{
- WARNING --------------------------------------------------------------------
Multiple #{entity} URLs were found:

#{values.join("\n")}

The URLs in #{values.first} will be used.

This could indicate that you're starting up more than one #{entity}, or
that a cleanup process from a prior test failed.

To fix this, delete #{scratch_dir}.
------------------------------------------------------------------------------
          }
        })

        true
      end
    end

    def set_env(var, value)
      puts "export #{var}='#{value}'"
      ENV[var] = value
    end
  end

  namespace :ops do
    task :start => 'test:env:cas' do
      cd File.expand_path('../../../devel/servers', __FILE__) do
        abort "PORT must be set" unless ENV['PORT']
        port = ENV['PORT']

        state_dir = "#{scratch_dir}/ops_mock/ops_mock.#{$$}"
        mkdir_p state_dir
        ENV['STATE_DIR'] = state_dir
        File.open("#{state_dir}/.urls", 'w') { |f| f.write(%Q{{"url":"http://localhost:#{port}"}}) }

        exec("bundle exec rackup -p #{port} ops_mock.ru")
      end
    end
  end
end

task :spec => ['test:env']
task :cucumber => ['test:env']
