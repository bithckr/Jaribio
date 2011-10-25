Jaribio::Application.routes.draw do
  match 'home' => 'home#index'
  root :to => "home#index"

  devise_for :users

  resources :test_cases, :path => '/cases', :except => :show do
    member do
      get 'executions'
    end 
  end

  resources :plans do
    member do
      get 'add_suites'
    end
    resources :executions
  end

  resources :suites, :except => :show do
    member do
      get 'add_cases'
    end
  end

  resources :executions

  match 'suites/:id/cases/:case_id' => "suites#associate",   :via => 'post',   :as => :associate_suite_case
  match 'suites/:id/cases/:case_id' => "suites#unassociate", :via => 'delete', :as => :unassociate_suite_case

  match 'plans/:id/suites/:suite_id' => "plans#associate", :via => 'post', :as => :associate_plan_suite
  match 'plans/:id/suites/:suite_id' => "plans#unassociate", :via => 'delete', :as => :unassociate_plan_suite
end
