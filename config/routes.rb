Rails.application.routes.draw do
  root 'pages#home'
  get 'signup'=>'users#new'
  post 'signup'=>'users#create'
  resources :users, only: [:edit, :update, :show, :index, :destroy] do
    resources :products
    resources :employees
  end
  post 'users/:id/deleted_products' => 'products#inactive', as: :user_inactive_products
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
