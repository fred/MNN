Publication::Application.routes.draw do
  require 'sidekiq/web'
  constraint = lambda { |request| request.env["warden"].authenticate? && request.env['warden'].user.is_admin? }
  constraints constraint do
    mount Sidekiq::Web => '/queue'
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: {registrations: :registrations}

  match 'search' => 'items#search', :as => :search
  match 'feed' => "items#feed", :as => :feed
  match 'languages/:language_id/items/page/:page' => 'items#index'
  match 'categories/:category_id/:page' => 'items#index'

  match 'news/:category/:id' => 'items#show', :as => :news_path
  
  # Omniauth
  match '/auth/:provider/callback', to: 'services#create'
  match '/auth/failure' => 'services#failure'
  resources :services, :only => [:create, :destroy]
  
  namespace "api" do 
    resources :git_push
  end
  
  # opinio_model
  resources :authors do
    resources :items
  end
  
  resources :items do
    resources :language
    resources :category
    opinio
  end

  resources :comments, :controller => 'opinio/comments' do
    get 'reply', :on => :member
  end

  resources :contacts
  resources :pages
  resources :roles
  resources :tags
  resources :general_tags
  resources :region_tags
  resources :country_tags
  resources :categories
  resources :attachments
  resources :scores
  resources :translations
  resources :languages do
    resources :items
  end

  # Main Items feed
  match '/atom' => 'items#index', :as => :items_atom, :defaults => { :format => 'atom' }
  match '/rss'  => 'items#index', :as => :items_rss,  :defaults => { :format => 'rss' }


  namespace :tasks do
    get 'sitemap'
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
  root :to => 'categories#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
