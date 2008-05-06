ActionController::Routing::Routes.draw do |map|

  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  
  map.resource :session 

  map.with_options(:controller => "sessions") do |sessions|
    sessions.login "login", :action => "new"
    sessions.logout "logout", :action => "destroy", :conditions => {:method => :delete}
  end

  map.resources :posts, :collection => {:pending => :get, :my => :get}, :member => {:publish => :post}
  map.resources :users
  map.profile 'profile', :controller => "users", :action => "edit"

  map.root :controller => "posts"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

end
