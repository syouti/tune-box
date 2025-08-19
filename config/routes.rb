Rails.application.routes.draw do
  get "favorite_albums/index"
  get "favorite_albums/create"
  get "favorite_albums/destroy"
  get "albums/index"
  get "albums/search"
  # ルートページをライブ一覧に設定
  root 'favorite_albums#index'

  # ライブイベント関連のルート
  resources :live_events do
    member do
      post 'favorite'     # お気に入りに追加
      delete 'unfavorite' # お気に入りから削除
    end
  end

  resources :favorite_albums, only: [:index, :create, :destroy] do
    collection do
      post :toggle
      post :update_layout
    end
  end

  # ユーザー認証関連のルート
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: [:show]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#destroy'  # GETでもログアウトできるように追加

  resources :favorite_albums, only: [:index, :create, :destroy]

  post 'favorite_albums/toggle', to: 'favorite_albums#toggle'

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
