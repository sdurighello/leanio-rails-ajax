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
        post 'add_user' => 'experiments#add_user'
        post 'remove_user' => 'experiments#remove_user'
      end
      resources :problem_experiments, controller: 'experiments', type: 'ProblemExperiment'
      resources :solution_experiments, controller: 'experiments', type: 'SolutionExperiment'
      resources :product_experiments, controller: 'experiments', type: 'ProductExperiment'
      resources :customer_experiments, controller: 'experiments', type: 'CustomerExperiment'

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
