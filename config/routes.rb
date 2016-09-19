Rails.application.routes.draw do



  resources :areas
  resources :canvases
  root 'landing_pages#index'

  devise_for :users

  post 'set_current_phase' => 'projects#set_current_phase'
  resources :projects do
    resources :teams
    resources :team_members
    resources :phases do
      resources :experiments do
        resources :steps, only: [:show, :update], controller: 'experiment/steps'
      end
      resources :sprints
      post 'update_experiment_assignment' => 'sprints#update_experiment_assignment'
    end
  end

end
