Quemfoi::Application.routes.draw do
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
#  mount Resque::Server.new, :at => "/resque"

  match 'certificates/search' => 'certificates#search', :as => :certificates_search
  match 'certificates/send_email' => 'certificates#send_email', :as => :certificate_send_email
  match 'certificates/edit_course/:id' => 'certificates#edit_course', :as => :certificate_edit_course
  match 'certificates/update_course' => 'certificates#update_course', :as => :certificate_update_course
  match ':id/participants' => 'courses#participants', :as => :participants
  match 'update_formation/:id' => 'activities#update_formation', :as => :update_formation
  match 'update_list/:id' => 'courses#update_list', :as => :update_list

  #root :to => 'certificates#index'
  root :to => 'courses#index'
  resources :courses  do
    resources :activities, :except => [ :index, :show ]
    resources :certificates, :only => [ :index, :show ]
    member do
      get 'participants_status'
    end
  end

  # Sample resource route with options:
  #   resources :products do
  #     member dos
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

