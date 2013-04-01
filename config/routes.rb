Pancakes::Application.routes.draw do
  root :to => 'frontend#show'
  match '*all' => 'frontend#show'
end
