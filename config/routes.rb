require 'sidekiq/web'
require 'admin_constraint'

LikeList::Application.routes.draw do
  root to: "home#index"
  resources :users, only: [ :index, :show, :edit, :update, :destroy ] do
    resources :likes, only: [ :update, :destroy ]
  end
  post '/likes/broken' =>            'likes#report_broken', as: :report_broken_like
  get  '/auth/:provider/callback' => 'sessions#create'
  get  '/signin' =>                  'sessions#new',        as: :signin
  get  '/signout' =>                 'sessions#destroy',    as: :signout
  get  '/auth/failure' =>            'sessions#failure'
  get  '/download_likes_script' =>   'download#likes_script'

  mount Sidekiq::Web => '/sidekiq',  constraints: AdminConstraint.new
end
