Publication::Application.routes.draw do

  require 'sidekiq/web'
  constraint = lambda { |request| request.env["warden"].authenticate? && request.env['warden'].user.is_admin? }
  constraints constraint do
    mount Sidekiq::Web => '/queue'
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: {registrations: :registrations}

  match 'opensearch' => 'items#opensearch', :as => :opensearch
  match 'benchmark_solr' => 'items#benchmark_solr', :as => :benchmark_solr
  match 'search' => 'items#search', :as => :search
  match 'feed' => "items#feed", :as => :feed
  match 'languages/:language_id/items/page/:page' => 'items#index'
  match 'categories/:category_id/:page' => 'items#index'

  match 'news/:category/:id' => 'items#show', :as => :news_path

  post '/tinymce_assets' => 'attachments#create'

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
    resources :comments, controller: 'opinio/comments'
  end

  resources :items do
    resources :language
    resources :category
    opinio
    get 'vote'
  end

  resources :comments, controller: 'opinio/comments' do
    get 'reply', on: :member
    get 'vote'
  end

  resources :links, only: [:index]
  resources :subscriptions, only: [:index, :destroy]
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

  root to: 'categories#index'

  match '*not_found', to: 'errors#error_404'
end
