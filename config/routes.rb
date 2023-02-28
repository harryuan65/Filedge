Rails.application.routes.draw do
  resources :user_files do
    resources :sharing_links, shallow: true, path: "share"
  end
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
