Oncapus::Application.routes.draw do

  devise_for :users

  get "profile/index"

  get "profile/show"

  get "profile/edit"

  get "profile/save"
  
  post "profile/save"
  
  get "profile/accept_code"

  get "profile/validate_code"
  
  get "profile/change_major"
  
  get "profile/change_name"

  get "profile/list_major"
  
  get "task/index"

  get "task/show"

  get "task/edit"

  get "task/save"
  
  post "task/save"
  
  get "task/upload_resource"
  
  post "task/upload_resource"
  
  match 'task' => 'task#index'
  
  get "course/index"

  get "course/show"

  get "course/edit"

  get "course/save"
  
  post "course/save"
  
  match 'course' => 'course#index'
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
  root :to => 'profile#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
