Rails.application.routes.draw do
  root 'pages#home'
  get 'signup'=>'users#new'
  post 'signup'=>'users#create'
  resources :users, only: [:edit, :update, :show, :index, :destroy] do
    resources :products
    resources :employees
    get 'deleted_products' => 'products#inactive', as: :inactive_products
    get 'deleted_employees' => 'employees#inactive', as: :inactive_employees
    get 'warehouse' => 'actions#warehouse', as: :warehouse
    get 'shopping' => 'actions#new_shopping', as: :new_shopping
    post 'shopping' => 'actions#create_shopping', as: :create_shopping
  end
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
