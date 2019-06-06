Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :projects, only: [:index, :new, :create]  do
    resources :reviews, only: :index
    get '/entities_data', to: 'entities#entities_data'
    resources :entities, only: [:index, :show] do
      get '/reviews', to: 'entities#reviews_for_entity', as: 'reviews'
    end
  end

  get :reviews_by_month_of_year, to: 'reviews#reviews_by_month_of_year'

  get '/my-profile', to: 'users#show'
  get 'edit-profile/:id/form', to: 'users#edit', as: 'edit_profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
