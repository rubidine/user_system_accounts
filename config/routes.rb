ActionController::Routing::Routes.draw do |map|
  map.resources :account_types
  map.resources :accounts,
                :collection => {
                  :join => :get
                }
  map.resources :account_requests
end
