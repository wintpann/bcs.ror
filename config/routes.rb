Rails.application.routes.draw do
  root 'pages#home'
  get 'signup'=>'users#new'
  post 'signup'=>'users#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
