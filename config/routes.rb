PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/pin', to: 'sessions#pin'
  post '/pin', to: 'sessions#pin'

  resources :posts, except: [:destroy] do

    member do
      post :vote
    end

    collection do
      get :archive
    end
    
    resources :comments, only: [:create] do
      member do
        post :vote
      end
    end
  end

  resources :categories, only: [:create, :show, :new]
  resources :users, only: [:create, :edit, :update, :show]
end
