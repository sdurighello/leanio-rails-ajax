Rails.application.routes.draw do
  resources :sprints
  resources :projects
  resources :phases
  resources :experiments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
