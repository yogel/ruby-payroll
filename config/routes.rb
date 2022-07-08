Rails.application.routes.draw do
  get 'home/index'
  get 'report' => 'report#index'
  resources :departments
  resources :employments
  resources :payrolls
  resources :employees

  get '/employments/:id/terminate', to: 'employments#terminate', as: 'terminate_employment'
  patch '/employments/:id/terminate', to: 'employments#terminate_employee', as: 'terminate_employment_post'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
