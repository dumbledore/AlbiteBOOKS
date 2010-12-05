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

  # statics
  map.home      'home/',      :controller => 'home', :action => 'home'
  map.reader    'reader/',    :controller => 'home', :action => 'reader'
  map.about     'about/',     :controller => 'home', :action => 'about'
  map.thanks    'thanks/',    :controller => 'home', :action => 'thanks'
  map.copyright 'copyright/', :controller => 'home', :action => 'copyright'
  map.contacts  'contacts/',  :controller => 'home', :action => 'contacts'

  # content
  map.resources :authors
  map.resources :author_aliases,  :except => [:index, :show]
  map.resources :books
  map.resources :book_aliases,    :except => [:index, :show]
  map.resources :translations,    :except => [:index]

  map.genres   'genres/',           :controller => 'genres', :action => 'index'
  map.genre    'genres/:genre',     :controller => 'genres', :action => 'show'

  map.subjects 'subjects/',         :controller => 'subjects', :action => 'index'
  map.subject  'subjects/:subject', :controller => 'subjects', :action => 'show'

  map.search_authors      'search/authors/:query',  :controller => 'authors', :action => 'search'
  map.search_authors_form 'search/authors/',        :controller => 'authors', :action => 'search_form'

  map.search_books        'search/books/:query',    :controller => 'books',   :action => 'search'
  map.search_books_form   'search/books/',          :controller => 'books',   :action => 'search_form'
  
  map.search              'search/:query',          :controller => 'home',    :action => 'search'
  map.search_form         'search/',                :controller => 'home',    :action => 'search_form'

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'home', :action => 'home'
  map.connect '*path', :controller => 'home', :action => 'redirect'
end