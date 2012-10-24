Til5::Application.routes.draw do
  match 'welcome' => 'welcome#index'
  resources :contract_templates, :only => [:show] do
    resources :contracts, :only => [:new]
  end
  resources :contracts, :only => [:create, :show] do
    collection do
      post :preview, :to => "contracts#preview"
    end
  end

  resources :contract_types
  namespace :admin do
    resources :schedules, :except => [:new, :edit, :update, :create, :delete] do
      get 'weekly/:year-:month-:day', :on => :collection, :action => :weekly, :as => :weekly
      resources :slots
    end
    resources :contract_types, :only => [:index, :new, :edit, :update, :create, :destroy] do
      resources :contract_templates, :only => [:index, :new, :create] do
      end
    end

    resources :contract_templates, :only => [:edit, :update, :destroy] do
      collection do
        post :preview, :to => "contract_templates#preview", :as => "preview"
      end
      member do
        get :preview
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
