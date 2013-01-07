DeliveryManagementTaskBoard::Application.routes.draw do

  resources :email_templates   do
    member do 
      get 'detail'
    end
  end

  resources :packages, :only => [:index, :show] do
    collection do 
       post 'package_to_component'
       get  'custom'
     end
  end
 
   resources :checkmen do 
     collection do
       post 'send_multiple'
       post 'mail_multiple'
       get 'item_detail'
       get 'import'
       post 'upload'
       match  'search' =>'checkmen#search', :via => [:get ,:post], :as => :search
     end
   end


   resources :components do
     member do
       get 'detail'
     end
     collection do
       post 'import'
       post 'upload'
     end
   end


    resources :objectresponsibles do
     member do
       get 'detail'
     end
   end


   resources :people do
     member do
       get 'mail_content_type_prodrel'
       get 'mail_content_type_all'
       get 'manual_mail'
       post 'manual_mail'
       get 'sendmail'
       get 'detail'
       get 'email_format'
     end
   end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #  match 'products/:id' => 'catalog#view'
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
  #root :to => 'checkman#import'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
