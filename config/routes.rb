ActionController::Routing::Routes.draw do |map|

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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  
  # User system
  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'activate'
  map.activate_user 'activate', :controller => 'users', :action => 'activate'
  map.forgot_password 'forgot', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/password/:reset_code', :controller => 'activations', :action => 'reset_password'
  map.register 'register', :controller => 'users', :action => 'new'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.profile 'profile', :controller => 'users', :action => 'edit'

  map.resources :user_sessions
  map.resources :users

  # search
#  map.autocomplete 'autocomplete', :controller => 'search', :action => 'autocomplete'
#  map.search 'search', :controller => 'search', :action => 'search_results'

  #statics
  map.reader 'reader', :controller => 'home', :action => 'reader'
  map.home 'home', :controller => 'home'

  map.resources :authors, :except => [:index, :show]

  map.authors 'authors/',          :controller => 'authors', :action => 'index'
  map.author  'authors/:id',       :controller => 'authors', :action => 'select'
#  map.connect 'authors/:id/:page', :controller => 'authors', :action => 'select'

  map.resources :aliases, :except => [:index, :show]

  map.resources :books, :except => [:index, :show]

  map.books   'books/',    :controller => 'books', :action => 'index'
  map.book    'books/:id', :controller => 'books', :action => 'select'
#  map.connect 'books/:id/:page', :controller => 'books', :action => 'select'
  
  map.resources :translations, :except => [:index, :show]

  map.download 'download/:id', :controller => 'translations', :action => 'download'

  map.genres   'genres/',           :controller => 'home', :action => 'genres'
  map.genre    'genres/:genre',     :controller => 'home', :action => 'genre'

  map.subjects 'subjects/',         :controller => 'home', :action => 'subjects'
  map.subject  'subjects/:subject', :controller => 'home', :action => 'subject'

  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'home'
end