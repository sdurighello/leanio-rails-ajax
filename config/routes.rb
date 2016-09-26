Rails.application.routes.draw do

  # Homepage, public
  root 'landing_pages#index'

  # Authentication on all routes except landing page
  devise_for :users

  # Authorization: each ctrl checks that current_user is member of the project and project is active
  resources :projects do

    post 'update_active_status' => 'projects#update_active_status'

    post 'add_user' => 'projects#add_user'
    post 'remove_user' => 'projects#remove_user'

    post 'set_current_phase' => 'projects#set_current_phase'

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

    resources :teams do
      resources :team_members
    end

  end

end
