Rails.application.routes.draw do
  get 'landing_pages/index'

  devise_for :users
  resources :team_members
  resources :teams
  resources :sprints
  resources :projects
  resources :phases
  resources :experiments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
