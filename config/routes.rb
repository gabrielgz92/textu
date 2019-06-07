Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :projects, only: [:index, :new, :create]  do
    resources :reviews, only: :index
    get '/reviews_for_entity', to: 'entities#reviews_for_entity'
    get '/entities_data', to: 'entities#entities_data'
    resources :entities, only: [:index, :show]
  end

  get :reviews_by_month_of_year, to: 'reviews#reviews_by_month_of_year'
  get :sentiment_score_averages, to:'reviews#sentiment_score_averages'

  get '/my-profile', to: 'users#show'
  get 'edit-profile/:id/form', to: 'users#edit', as: 'edit_profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
