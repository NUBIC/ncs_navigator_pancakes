require 'sinatra'

$DATA = %Q{
{
    "events": [], 
    "filters": {}
}
}

abort 'PORT must be set' unless ENV['PORT']
set :port, ENV['PORT']

get '/api/v1/events' do
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
