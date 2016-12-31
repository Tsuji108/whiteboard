# frozen_string_literal: true
Rails.application.routes.draw do
  get 'timetables/new'

  # TODO: 仮のルート
  root   'sessions#new'

  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get   'resend'
    end
    resources :mailing_lists, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        get 'confirm'
        get 'send_ml'
        get 'applay_saved_ml'
        get 'destroy_saved_ml'
      end
    end
    resources :timetables do
      member do
        get 'confirm'
        get 'publish_timetable'
        get 'applay_saved_timetable'
        get 'destroy_saved_timetable'
      end
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
