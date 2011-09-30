Jaribio::Application.routes.draw do
  match 'home' => 'home#index'
  root :to => "home#index"

  devise_for :users

  resources :test_cases, :path => '/cases'
  resources :plans
  resources :suites

  match 'suites/:id/cases/:test_case_id' => "suites#unassociate", :via => 'delete', :as => :unassociate

end
