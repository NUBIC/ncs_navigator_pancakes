require 'sinatra'

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

abort 'PORT must be set' unless ENV['PORT']
set :port, ENV['PORT']

trap('TERM') { exit! 0 }

get '/users.json' do
  content_type 'application/json'
  $USERS
end

# vim:ts=2:sw=2:et:tw=78:ft=ruby
