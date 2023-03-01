Rails.application.routes.draw do
  root "user_files#index"
  resources :user_files, except: %i[new edit update] do
    member do
      get :download
    end
    resources :sharing_links, shallow: true, path: "share", only: %i[show create]
  end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
