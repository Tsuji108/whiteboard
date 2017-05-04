# frozen_string_literal: true
Rails.application.routes.draw do

  root   'sessions#new'

  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
    member do
      get   'resend'
      get   'add_admin'
      get   'remove_admin'
    end
    resources :mailing_lists, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        get 'confirm'
        get 'send_ml'
        get 'applay_saved_ml'
        get 'destroy_saved_ml'
      end
    end
    resources :timetables, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        get 'confirm'
        get 'publish_timetable'
        get 'applay_saved_timetable'
        get 'destroy_saved_timetable'
        post 'reservation'
        delete 'delete_reservation'
      end
    end
  end

  resources :account_activations, only: [:edit, :create] do
    collection do
      get 'resend'
    end
  end

  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :notifications,       only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get 'creator'
    end
  end
  
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
