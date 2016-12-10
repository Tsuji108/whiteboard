Rails.application.routes.draw do
  
  # TODO:仮のルート
  root 'users#new'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  
end
