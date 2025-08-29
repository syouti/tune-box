# セキュリティ設定
Rails.application.configure do
  # セッション設定の強化
  config.session_store :cookie_store,
    key: '_tune_box_session',
    secure: Rails.env.production?,
    httponly: true,
    same_site: :lax

  # パラメータフィルタリング
  config.filter_parameters += [
    :password,
    :password_confirmation,
    :credit_card_number,
    :ssn
  ]

  # ログフィルタリング
  config.filter_parameters += [:password, :password_confirmation]

  # セキュリティヘッダーの設定
  config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'DENY',
    'X-Content-Type-Options' => 'nosniff',
    'X-XSS-Protection' => '1; mode=block',
    'X-Download-Options' => 'noopen',
    'X-Permitted-Cross-Domain-Policies' => 'none',
    'Referrer-Policy' => 'strict-origin-when-cross-origin'
  }
end
