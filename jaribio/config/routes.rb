Jaribio::Application.routes.draw do
  match 'home' => 'home#index'
  root :to => "home#index"

  devise_for :users

  resources :test_cases, :path => '/cases'
  resources :plans
  resources :suites do
    member do
      get 'add_cases'
    end
  end

  match 'suites/:id/cases/:case_id' => "suites#associate",   :via => 'post',   :as => :associate_suite_case
  match 'suites/:id/cases/:case_id' => "suites#unassociate", :via => 'delete', :as => :unassociate_suite_case
end
