Jaribio::Application.routes.draw do

  devise_for :users

  # Devise requires a root assignment
  root :to => "home#index"

end
