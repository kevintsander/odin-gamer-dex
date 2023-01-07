Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  resources :users, only: %i[show index] do
    resources :posts
    resources :user_relationships, only: %i[create update destroy], param: :friend_id
    resources :games, only: %i[index create destroy]
  end

  scope 'posts/:id' do
    resources :post_reactions, controller: :reactions, only: %i[create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_scope :user do
    root 'users#current_user_home'
    # get '/sign-in' => 'devise/sessions#new', as: :login
  end
end
