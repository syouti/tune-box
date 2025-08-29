Rails.application.routes.draw do
  # メール確認機能
  get 'confirm_email', to: 'email_confirmations#confirm'
  get 'resend_confirmation', to: 'email_confirmations#resend'
  post 'resend_confirmation', to: 'email_confirmations#resend'

  root 'home#index'
  get "home/index"
  get "albums/index"
  get "albums/search"
  get 'list_builder', to: 'list_builder#index'
  get 'albums', to: 'list_builder#index'

  # ライブイベント関連
  resources :live_events do
    member do
      post 'favorite'
      delete 'unfavorite'
    end
  end

  # お気に入りアルバム関連（1つにまとめて、member と collection を正しく配置）
  resources :favorite_albums do
    member do
      get :share
      post :generate_share_image
    end
    collection do
      post :toggle
      post :update_layout
      patch :update_positions  # この行を追加
      post :save_to_account
      post :share
      delete :bulk_destroy
      get :generate_share_image
      get :preview_share_image # Added for preview
    end
  end



  # ユーザー認証関連
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: [:show, :edit, :update]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#destroy'

  # セッションクリア用（開発環境のみ）
  get 'clear_session', to: 'sessions#clear_session' if Rails.env.development?

    # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  get "health" => "health#check"
  get "health/detailed" => "health#detailed"

  # エラーハンドリング
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all
end
