Rails.application.routes.draw do
  root 'pages#home'
  get 'signup'=>'users#new'
  post 'signup'=>'users#create'
  resources :users, only: [:edit, :update, :show, :index, :destroy] do
    resources :products
    resources :employees do
      get 'new_work_session' => 'actions#new_work_session', as: :new_work_session
      post 'create_work_session' => 'actions#create_work_session', as: :create_work_session
      get 'end_work_session' => 'actions#end_work_session', as: :end_work_session
      post 'delete_work_session' => 'actions#delete_work_session', as: :delete_work_session
    end
    get 'deleted_products' => 'products#inactive', as: :inactive_products
    get 'deleted_employees' => 'employees#inactive', as: :inactive_employees
    get 'warehouse' => 'actions#warehouse', as: :warehouse
    get 'shopping' => 'actions#new_shopping', as: :new_shopping
    post 'shopping' => 'actions#create_shopping', as: :create_shopping
    get 'throwing' => 'actions#new_throwing', as: :new_throwing
    post 'throwing' => 'actions#create_throwing', as: :create_throwing
    get 'events' => 'actions#events', as: :events
    get 'event/:id' => 'actions#event', as: :event
  end
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
