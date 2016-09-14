Rails.application.routes.draw do

  root 'landing_pages#index'

  devise_for :users

  resources :projects do
    resources :teams
    resources :team_members
    resources :phases do
      resources :experiments
      resources :sprints
    end
  end

end
