CalendarReminders::Application.routes.draw do
  resources "appointments"
  resources "contacts"
  resources :profile
  get "authentication/index"
  get "info/about"
  get "info/contact"
  get "home/index"

  get "sessions/new"
  get "sessions/authorize"
  delete "sessions/destroy"

  root 'home#index'
end
