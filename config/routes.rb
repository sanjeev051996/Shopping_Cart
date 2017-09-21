Rails.application.routes.draw do
  
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      get '/profile', to:"users#profile", as: "profile"
      get '/profile/update', to: 'users#profile_settings', as: "update_profile"
      get '/login', to: 'sessions#new'
    end
  end
  resources :carts, only: [:destroy] do
    collection do
      patch '/update', to: "carts#update_quantity", as: "update_quantity"
      post '/add_item', to: "carts#add_item", as: "add_item"
      delete '/remove_item', to: "carts#remove_item", as: "remove_item"
      get '/display', to: "carts#show"
    end
  end 
  resources :products
  resources :orders do
    collection do
      patch '/:id/process_payment', to: 'orders#process_payment', as: "process_payment"
      post '/:id/pay', to: "orders#payment", as: "pay"
    end
  end
  resources :sessions, only: [] do
    collection do 
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
  root 'welcome#index'
end
