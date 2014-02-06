CalendarReminders::Application.routes.draw do
  resources :contacts
  resources :appointments
  resources :contacts
  resources :profile
  resources :messages, only: [:create]

  get "authentication/index"
  get "info/about"
  get "info/contact"
  get "home/index"

  get "sessions/new"
  get "sessions/authorize"
  delete "sessions/destroy"

  root 'home#index'
end
