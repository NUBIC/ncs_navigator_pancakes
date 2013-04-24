require 'aker'
require 'sinatra'

$DATA = %Q{
{
    "events": [],
    "filters": {}
}
}

abort 'PORT must be set' unless ENV['PORT']
set :port, ENV['PORT']

Aker.configure do
  api_mode :cas_proxy
  authorities :cas, :automatic_access
  portal :NCSNavigator

  cas_parameters({
    base_url: ENV['CAS_BASE_URL']
  })
end

use Rack::Session::Cookie, :secret => 'supersekrit'

Aker::Rack.use_in(Sinatra::Application)

OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:verify_mode] = OpenSSL::SSL::VERIFY_NONE

get '/api/v1/events' do
  env['aker.check'].authentication_required!

  if params.empty?
    status 400
    return ''
  end

  if request.env['HTTP_X_CLIENT_ID'].nil?
    status 400
    return ''
  end

  content_type 'application/json'
  $DATA
end
