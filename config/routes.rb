Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :projects, only: :index  do
    resources :reviews, only: :index
    resources :entities, only: [:index, :show] do
      resources :reviews, only: :index
    end
  end

  get '/my-profile', to: 'users#show'
  get 'edit-profile/:id/form', to: 'users#edit', as: 'edit_profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
