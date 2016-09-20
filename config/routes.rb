Rails.application.routes.draw do

  root 'landing_pages#index'

  devise_for :users

  post 'set_current_phase' => 'projects#set_current_phase'
  resources :projects do
    resources :teams
    resources :team_members
    resources :phases do

      resources :experiments do
        post 'add_hypothesis' => 'experiments#add_hypothesis'
        post 'remove_hypothesis' => 'experiments#remove_hypothesis'
      end

      resources :sprints
      post 'update_experiment_assignment' => 'sprints#update_experiment_assignment'

    end
    resources :canvases do
      resources :areas do
        post 'add_hypothesis' => 'areas#add_hypothesis'
        post 'remove_hypothesis' => 'areas#remove_hypothesis'
      end
    end
    resources :hypotheses
    resources :results
  end

end
