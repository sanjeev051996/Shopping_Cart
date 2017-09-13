Rails.application.routes.draw do
  
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users 
  resources :orders
  resources :carts  
  resources :products
  patch 'orders/:id/process_payment', to: 'orders#process_payment'
  post 'orders/:id/pay' => "orders#payment", as: "order_pay"
  post 'cart_items/:id/add' => "cart_items#add_quantity", as: "cart_item_add"
  post 'cart_items/:id/reduce' => "cart_items#reduce_quantity", as: "cart_item_reduce"
  post 'cart_items' => "cart_items#create"
  get 'cart_items/:id' => "cart_items#show", as: "cart_item"
  delete 'cart_items/:id' => "cart_items#destroy"
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  root 'welcome#index'
end
