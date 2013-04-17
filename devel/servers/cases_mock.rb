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
  content_type 'application/json'
  $DATA
end
