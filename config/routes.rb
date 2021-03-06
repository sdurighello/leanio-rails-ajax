Rails.application.routes.draw do

  # Homepage, public
  root 'landing_pages#index'

  # Authentication on all routes except landing page
  devise_for :users

  # Authorization: each ctrl checks that current_user is member of the project and project is active
  resources :projects do

    post 'update_active_status' => 'projects#update_active_status'

    get 'show_users' => 'projects#show_users'
    post 'search_users' => 'projects#search_users'
    post 'add_user' => 'projects#add_user'
    post 'remove_user' => 'projects#remove_user'

    post 'set_current_phase' => 'projects#set_current_phase'

    resources :phases, except: [:index] do

      resources :experiments, except: [:index, :new, :create, :edit, :update, :destroy, :show] do
        post 'add_hypothesis' => 'experiments#add_hypothesis'
        post 'remove_hypothesis' => 'experiments#remove_hypothesis'
        post 'add_user' => 'experiments#add_user'
        post 'remove_user' => 'experiments#remove_user'
      end
      resources :problem_experiments, controller: 'experiments', type: 'ProblemExperiment'
      resources :solution_experiments, controller: 'experiments', type: 'SolutionExperiment'
      resources :product_experiments, controller: 'experiments', type: 'ProductExperiment'
      resources :customer_experiments, controller: 'experiments', type: 'CustomerExperiment'

      resources :sprints, except: [:index]
      post 'update_experiment_assignment' => 'sprints#update_experiment_assignment'

    end

    resources :canvases, except: [:index] do
      resources :areas, except: [:index] do
        post 'add_hypothesis' => 'areas#add_hypothesis'
        post 'remove_hypothesis' => 'areas#remove_hypothesis'
      end
    end

    resources :hypotheses, except: [:index]
    resources :results, except: [:index]

  end

end
