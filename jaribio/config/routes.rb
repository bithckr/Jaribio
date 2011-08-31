Jaribio::Application.routes.draw do
  match 'home' => 'home#index'
  root :to => "home#index"

  devise_for :users

  resources :test_cases
  resources :plans
  resources :suites

end
