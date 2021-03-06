ActionController::Routing::Routes.draw do |map|

  map.aliases :resources, :posts => 'artigos', :users => 'usuarios', :bloggers => 'bloggers_row'
  map.aliases :actions, :new => 'novo', :edit => 'editar', :logout => 'sair', :my => 'meus', :pending => 'pendentes', :all => 'todos'

  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  
  map.resource :session
  
  map.home "sobre", :controller => "home"

  map.with_options(:controller => "sessions") do |sessions|
    sessions.login "entrar", :action => "new"
    sessions.logout "sair", :action => "destroy", :conditions => {:method => :delete}
  end

	map.resources :widget, :collection => { :widget => :get, :embedded => :get }
  map.resources :posts, :collection => {:pending => :get, :my => :get, :search => :get, :all => :get}, :member => {:publish => :post, :refuse => :post}
  map.resources :users
  map.resources :bloggers
  map.profile 'perfil', :controller => "users", :action => "edit"
  
  map.ruby_inside '/ruby_inside', :controller => 'widget', :action => 'ruby_inside'
  
  map.connect '/meus/:id', :controller => "posts", :action => "my"

  map.root :controller => "posts", :action => 'index', :format => 'html'

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
