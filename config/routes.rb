Rails.application.routes.draw do
  # ルートページをライブ一覧に設定
  root 'live_events#index'

  # ライブイベント関連のルート
  resources :live_events

  # ユーザー認証関連のルート
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: [:show]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#destroy'  # GETでもログアウトできるように追加

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
