Rails.application.routes.draw do

  root 'landing_pages#index'

  devise_for :users

  post 'set_current_phase' => 'projects#set_current_phase'
  resources :projects do
    resources :teams
    resources :team_members
    resources :phases do
      resources :experiments
      resources :sprints
      post 'update_experiment_assignment' => 'sprints#update_experiment_assignment'
    end
    resources :canvases do
      resources :areas
    end
    resources :hypotheses
    resources :results
  end

end
