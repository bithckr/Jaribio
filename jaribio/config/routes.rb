Jaribio::Application.routes.draw do
  resources :pre_steps

  resources :steps

  match 'home' => 'home#index'
  root :to => "home#index"

  devise_for :users
  resources :token_authentications, :only => [:create, :destroy]

  resources :test_cases, :path => '/cases' do
    member do
      get 'executions'
      post 'sort'
      post 'copy'
    end 
    resources :steps
  end

  resources :plans do
    member do
      get 'add_suites'
      post 'close'
    end

    collection do
      get 'open'
    end

    resources :test_cases, :path => '/cases', :only => [] do
      resources :executions, :only => [:create]
    end
  end

  resources :suites, :except => :show do
    member do
      get 'add_cases'
      post 'sort'
    end
  end

  resources :executions, :only => [:show]

  match 'suites/:id/cases/:case_id' => "suites#associate",   :via => 'post',   :as => :associate_suite_case
  match 'suites/:id/cases/:case_id' => "suites#unassociate", :via => 'delete', :as => :unassociate_suite_case

  match 'plans/:id/suites/:suite_id' => "plans#associate", :via => 'post', :as => :associate_plan_suite
  match 'plans/:id/suites/:suite_id' => "plans#unassociate", :via => 'delete', :as => :unassociate_plan_suite
end
