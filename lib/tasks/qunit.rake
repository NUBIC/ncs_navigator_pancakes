namespace :qunit do
  desc 'Run Javascript tests in PhantomJS'
  task :headless do
    runner = File.expand_path('../../../spec/support/phantomjs_runner.js', __FILE__)
    suite = 'http://localhost:PORT/assets/javascript_unit_tests.html'
    port = 1023 + rand(65535 - 1023)
    pid = File.expand_path("../../../tmp/pids/server.#{port}.pid", __FILE__)

    begin
      system "rails server -p #{port} -d -P #{pid}"
      suite = URI.parse(suite.sub('PORT', port.to_s))

      puts "Waiting for #{suite} to respond..."

      1.upto(30) do
        sh "curl -s #{suite}"
        break if $?.success?
        sleep 1
      end

      if !$?.success?
        abort "Could not contact #{suite}"
      else
        sh "phantomjs #{runner} #{suite}"
      end
    ensure
      sh "kill -INT `cat #{pid}`"
    end
  end
end

task 'spec:javascripts' => 'qunit:headless'

task :default => 'qunit:headless'
