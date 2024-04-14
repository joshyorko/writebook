Rails.application.routes.draw do
  root "books#index"

  resource :first_run, only: %i[ show create ]
  resource :session, only: %i[ new create destroy ]

  get "join/:join_code", to: "users#new", as: :join
  post "join/:join_code", to: "users#create"

  resources :books do
    resources :leaves

    scope module: "books" do
      namespace :leaves do
        resources :moves, only: :create
      end
    end

    resources :sections
    resources :pictures
    resources :pages do
      scope module: "pages" do
        resources :edits, only: :show
      end
    end
  end

  direct :leafable do |leaf, options|
    route_for "book_#{leaf.leafable_name}", leaf.book, leaf.leafable, options
  end

  direct :edit_leafable do |leaf, options|
    route_for "edit_book_#{leaf.leafable_name}", leaf.book, leaf.leafable, options
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
