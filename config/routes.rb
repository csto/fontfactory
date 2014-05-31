Ff::Application.routes.draw do
  devise_for :users
  match 'download', to: "pages#download", via: :post
  
  resources :fonts
  
  root to: 'pages#landing'
end
