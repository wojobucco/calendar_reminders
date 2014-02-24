CalendarReminders::Application.routes.draw do
  delete "contacts/destroy_selected"
  resources :contacts

  resources :appointments do
    member do
      post 'send_reminder'
    end
  end

  resources :profile, only: [:index]

  resources :reminders, only: [:create]

  resources :settings, only: [:index, :update]

  get "authentication/index"
  get "info/about"
  get "info/contact"
  get "home/index"

  get "sessions/new"
  get "sessions/authorize"
  delete "sessions/destroy"

  root 'home#index'
end
