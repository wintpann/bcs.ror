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
    get 'new_fare' => 'actions#new_fare', as: :new_fare
    post 'create_fare' => 'actions#create_fare', as: :create_fare
    get 'new_tax' => 'actions#new_tax', as: :new_tax
    post 'create_tax' => 'actions#create_tax', as: :create_tax
    get 'new_equipment' => 'actions#new_equipment', as: :new_equipment
    post 'create_equipment' => 'actions#create_equipment', as: :create_equipment
    get 'new_other_expense' => 'actions#new_other_expense', as: :new_other_expense
    post 'create_other_expense' => 'actions#create_other_expense', as: :create_other_expense
  end
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
