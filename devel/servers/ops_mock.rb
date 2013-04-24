require 'aker'
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

sio = StringIO.new(<<END)
users:
  psc_application:
    password: t00t!!
END

static = Aker::Authorities::Static.new.load!(sio)

Aker.configure do
  api_mode :http_basic
  authorities static
end

use Rack::Session::Cookie, :secret => 'supersekrit'

Aker::Rack.use_in(Sinatra::Application)

OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:verify_mode] = OpenSSL::SSL::VERIFY_NONE

get '/users.json' do
  env['aker.check'].authentication_required!

  content_type 'application/json'
  $USERS
end

# vim:ts=2:sw=2:et:tw=78:ft=ruby
