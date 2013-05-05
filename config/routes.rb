Pancakes::Application.routes.draw do
  root :to => 'frontend#show'

  scope '/api/v1', :module => 'api' do
    with_options :only => :index do |enum|
      enum.resources :event_types
      enum.resources :data_collectors
      enum.resources :study_locations
    end

    resources :event_searches, :only => [:create, :update, :show] do
      member do
        get :status
        post :refresh
      end
    end

    put '/mdes_version' => 'mdes_version#set'

    match '*all' => 'landing#unknown'
  end

  match '*all' => 'frontend#show'
end
