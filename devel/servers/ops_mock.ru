require 'sinatra'

abort "STATE_DIR must be set" unless ENV['STATE_DIR']

at_exit do
  FileUtils.rm_rf(ENV['STATE_DIR'])
end

$USERS = <<-END
[
    {
        "first_name": "Curtis", 
        "last_name": "Grund", 
        "username": "cvg123"
    }, 
    {
        "first_name": "Franklin", 
        "last_name": "Rickard", 
        "username": "fcr456"
    }, 
    {
        "first_name": "Teressa", 
        "last_name": "Timpson", 
        "username": "tst789"
    }, 
    {
        "first_name": "Amber", 
        "last_name": "Larson", 
        "username": "arl012"
    }
]
END

class OpsMock < Sinatra::Base
  get '/users.json' do
    content_type 'application/json'
    $USERS
  end
end

run OpsMock

# vim:ts=2:sw=2:et:tw=78:ft=ruby
