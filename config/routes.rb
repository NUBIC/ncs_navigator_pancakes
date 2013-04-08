Pancakes::Application.routes.draw do
  root :to => 'frontend#show'

  scope '/api/v1', :module => 'api' do
    resources :event_types, :only => :index
    put '/mdes_version' => 'mdes_version#set'

    match '*all' => 'landing#unknown'
  end

  match '*all' => 'frontend#show'
end
