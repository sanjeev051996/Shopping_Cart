Rails.application.routes.draw do
  
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  get '/profile/update', to: 'users#profile_settings', as: "update_profile"
  get '/profile', to:"users#profile", as: "profile" 
  resources :orders
  resource :cart  
  resources :products
  patch 'orders/:id/process_payment', to: 'orders#process_payment'
  post 'orders/:id/pay', to: "orders#payment", as: "order_pay"
  post 'cart/add', to: "carts#add_quantity", as: "add_quantity"
  post 'cart/reduce', to: "carts#reduce_quantity", as: "reduce_quantity"
  post '/add_to_cart', to: "carts#add_item", as: "add_to_cart"
  delete '/remove_from_cart', to: "carts#remove_item", as: "remove"
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  root 'welcome#index'
end
