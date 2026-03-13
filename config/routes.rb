Rails.application.routes.draw do
  resources :blog_posts do
    collection do
      # `collection` — routes that act on the whole collection (no specific record needed)
      # These don't have an :id in the URL because you're not working with an existing post — you're creating something new or listing something.
      get  "ai_new"
      post "create_with_ai"
    end
    member do
      # `member` — routes that act on a specific record (needs an id).
      # These have :id in the URL because you need to know which post to revise.
      get   "ai_revise"
      patch "revise_with_ai"
      patch "publish"
      patch "schedule"
      patch "cancel_schedule"
    end
  end
  resources :teachings
  resources :grant_awards
  resources :research_items
# FriendlyId: `/users/john@example.com` works alongside `/users/1`
  devise_for :users
  resource :profile, only: [:show, :update]
  root to: "pages#home"
  get "cv/download", to: "pages#download_cv", as: :download_cv

  resources :contacts, only: [ :new, :create ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
