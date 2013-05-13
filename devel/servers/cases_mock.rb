require 'aker'
require 'sinatra'

$DATA = %Q{
{
    "events": [
        {
            "data_collector_usernames": [
                "abc123",
                "fgh456"
            ],
            "disposition_code": {
                "category_code": 2,
                "disposition": "Vacant housing unit",
                "interim_code": "040"
            },
            "event_id": "242d6bc8-cc9b-469e-bb70-e583982f6537",
            "event_type": {
                "display_text": "Foo",
                "local_code": "-99"
            },
            "links": [],
            "participant_id": "a6e2a94f-bdf6-4400-a95a-214dd67768e9",
            "scheduled_date": "2013-01-01"
        }
    ],
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

$ideal = false

post '/_controls/behave' do
  $ideal = true
  status 200
end

post '/_controls/misbehave' do
  $ideal = false
  status 200
end

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

  if $ideal
    $DATA
  else
    sleep(rand)
    if rand < 0.3
      status 403
    elsif rand > 0.7
      raise "Uh oh"
    else
      $DATA
    end
  end
end
