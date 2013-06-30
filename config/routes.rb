Til5::Application.routes.draw do

  resources :lockers do
    member do
      get :rent, :as => :new_rent, :to => "lockers#new_rent"
      post :rent, :as => :create_rent, :to => "lockers#create_rent"
      post :restore
    end
  end

  resources :leads do
    member do
      get :survey, :as => :new_survey, :to => "leads#new_survey"
      post :survey, :as => :survey, :to => "leads#survey"
    end
  end

  resources :accounts do
    member do
      get :renew
      put :do_renew
      get :suspend
      put :do_suspend
      get :transfer
      put :do_transfer
      post :resume
      get :participate, :as => :new_participation, :to => "accounts#new_participation"
      put :participate, :as => :update_participation, :to => "accounts#update_participation"
      get :survey, :as => :new_survey, :to => "accounts#new_survey"
      post :survey, :as => :survey, :to => "accounts#survey"
      get :edit_membership_state
      put :update_membership_state
      get :new_locker
      post :create_locker
      put :create_locker
    end
    collection do
      get :options, :to => "accounts#options"
    end
    resources :contracts, :only => [:edit, :update, :show] do
      member do
        post :sign, :to => "contracts#sign"
      end
    end
  end


  resources :participations, :only => [:destroy] do
    member do
      post :attend
      get :transfer, :as => :new_lesson_transfer, :to => "participations#new_lesson_transfer"
      put :transfer, :as => :update_lesson_transfer, :to => "participations#update_lesson_transfer"
    end
  end

  match 'test' => 'home#test'

  match 'welcome' => 'welcome#index'
  match 'welcome/:id' =>'welcome#show'
  resources :contracts, :only => [:index, :create, :show] do
    member do
      post :sign, :to => "contracts#sign"
    end
    collection do
      post :preview, :to => "contracts#preview"
    end
  end

  resources :users do
    collection do
      post :redraw, :to => "users#redraw"
    end
    member do
      post :redraw, :to => "users#redraw"
      post :add_appointment, :to =>"users#add_appointment"
      put :add_appointment, :to => "users#add_appointment"
      get :new_appointment, :to => "users#new_appointment"
      get :appointments, :to => "users#appointments"
    end
    get 'appointments/:year-:month-:day', :on => :member, :action => :appointments, :as => :appointments_by_date
  end

  resources :appointments, :only => [:show, :destroy] do
    member do
      post :cancel, :to => "appointments#cancel"
    end
  end

  namespace :admin do
    resources :schedules, :only => [:index] do
      collection do
        get ':year-:month-:day', :action => :show, :as => :show
        put ':year-:month-:day', :action => :update, :as => :update
        get ':year-:month-:day/edit', :action => :edit, :as => :edit
      end
    end

    resources :membership_types, :only => [:index, :new, :edit, :update, :create, :destroy]
    resources :contract_types, :only => [:index, :new, :edit, :update, :create, :destroy] do
      resources :contract_templates, :only => [:index, :new, :create] do
      end
    end

    resources :lessons, :only => [:index, :new, :edit, :update, :create, :destroy]

    resources :lockers, :only => [:index, :destroy, :new, :create] do
    end


    resources :contract_templates do
      member do
        get :preview
      end
    end

    resources :user_ranks, :only => [:index] do
      collection do
        post :sort, :to => "user_ranks#sort", :as => "sort"
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
