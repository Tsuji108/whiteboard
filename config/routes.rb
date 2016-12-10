Rails.application.routes.draw do
  
<<<<<<< HEAD
=======
  root 'users#new'
  
>>>>>>> master
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  
end
