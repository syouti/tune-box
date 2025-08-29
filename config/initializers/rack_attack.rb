class Rack::Attack
  # キャッシュストアの設定
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # ログイン試行制限
  throttle('login/email', limit: 5, period: 1.hour) do |req|
    req.params['session']['email'] if req.path == '/login' && req.post?
  end

  # 新規登録制限
  throttle('signup/ip', limit: 3, period: 1.hour) do |req|
    req.ip if req.path == '/signup' && req.post?
  end

  # メール確認再送信制限
  throttle('email_confirmation/ip', limit: 5, period: 1.hour) do |req|
    req.ip if req.path == '/email_confirmations/resend' && req.post?
  end

  # API呼び出し制限
  throttle('api/ip', limit: 100, period: 1.hour) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  # スクリーンショット機能制限
  throttle('screenshot/ip', limit: 10, period: 1.hour) do |req|
    req.ip if req.path.include?('screenshot') && req.post?
  end

  # ブロックされたリクエストの処理
  blocklist('blocklist/ip') do |req|
    # 既知の悪意のあるIPアドレスをブロック
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 1.hour, bantime: 24.hours) do
      req.path.start_with?('/login') && req.post? && req.params['session']['email'].present?
    end
  end

  # レスポンスの設定
  self.blocklisted_response = lambda do |env|
    [403, {'Content-Type' => 'application/json'}, [{error: 'Too many requests'}.to_json]]
  end

  self.throttled_response = lambda do |env|
    [429, {'Content-Type' => 'application/json'}, [{error: 'Rate limit exceeded'}.to_json]]
  end
end
