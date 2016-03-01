Rails.application.routes.draw do
  root 'stations#index'

  get 'static_pages/about'
  get 'static_pages/api'

  resource :stations, only: [:index, :show]

  # api
  namespace :api do
    namespace :v1 do
      resources :companies, only: [:index]
      resources :providers, only: [:show]
    end
  end
end
