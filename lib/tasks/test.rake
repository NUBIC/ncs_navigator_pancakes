require 'castanet/testing'
require 'term/ansicolor'
require 'timeout'

scratch_dir = Rails.root.join('tmp', 'castanet-testing')

Castanet::Testing::CallbackServerTasks.new(:scratch_dir => "#{scratch_dir}/callback")
Castanet::Testing::JasigServerTasks.new(:scratch_dir => "#{scratch_dir}/server",
                                        :jasig_url => 'http://downloads.jasig.org/cas/cas-server-3.4.12-release.tar.gz',
                                        :jasig_checksum => 'd67466b0d3441b3a5817d1a918add6a0f598a3367ca595c33e6efcef5b170ab6')

namespace :test do
  desc 'Set up process environment for tests'
  task :env do
    $stderr.puts <<-END
Looking for test infrastructure.  Will give up after 30 seconds.

If you haven't done so already, run foreman start in a separate shell or as a
background process.
    END

    Timeout::timeout(30) do
      Rake::Task['test:env:cas'].invoke
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

You can use the castanet:testing:{jasig, callback}:cleanall tasks to
eliminate old data.  Alternatively, you can delete
#{scratch_dir}.
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
end

task :spec => ['test:env']
task :cucumber => ['test:env']
