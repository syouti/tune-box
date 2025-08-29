# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception, prepend: true

  include SessionsHelper
  # include LogHelper

  helper_method :current_user, :user_signed_in?, :guest_session_id, :guest_favorite_albums, :guest_user?

  # 基本的なセキュリティヘッダーを追加（一時的に無効化）
  # before_action :set_basic_security_headers



  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    # ユーザーが見つからない場合はセッションをクリア
    session[:user_id] = nil
    nil
  end

  def guest_user?
    !user_signed_in? && session[:guest_mode]
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end

  def require_confirmed_user
    if user_signed_in? && !current_user.confirmed?
      flash[:alert] = 'メールアドレスの確認が必要です。'
      redirect_to login_path
    end
  end

  def require_login_or_guest
    # ゲストパラメータがある場合はゲストモードを設定
    session[:guest_mode] = true if params[:guest] == 'true' && !user_signed_in?

    # ログインユーザーまたはゲストモードの場合は許可
    return if user_signed_in? || session[:guest_mode]

    # それ以外の場合はログインページにリダイレクト
    redirect_to login_path, alert: 'ログインしてください'
  end

    # セキュリティヘッダーの強化
  def set_basic_security_headers
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
    response.headers['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'

    # CSP (Content Security Policy) の設定（セキュリティ強化）
    if Rails.env.development?
      # 開発環境ではGoogle AdSenseの動作確認のため一時的に緩和
      csp_policy = [
        "default-src 'self'",
        "script-src 'self' 'unsafe-inline' 'unsafe-eval' https:",
        "style-src 'self' 'unsafe-inline' https:",
        "img-src 'self' data: https: http:",
        "font-src 'self' https:",
        "connect-src 'self' https:",
        "frame-src 'self' https:",
        "frame-ancestors 'none'",
        "object-src 'none'",
        "base-uri 'self'"
      ].join('; ')
    else
      csp_policy = [
        "default-src 'self'",
        "script-src 'self' https://cdn.jsdelivr.net https://www.googletagmanager.com https://pagead2.googlesyndication.com https://ep2.adtrafficquality.google",
        "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com",
        "img-src 'self' data: https: http: https://pagead2.googlesyndication.com https://googleads.g.doubleclick.net",
        "font-src 'self' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.gstatic.com",
        "connect-src 'self' https://api.spotify.com https://www.google-analytics.com https://pagead2.googlesyndication.com https://googleads.g.doubleclick.net https://ep1.adtrafficquality.google https://ep2.adtrafficquality.google",
        "frame-src 'self' https://pagead2.googlesyndication.com https://googleads.g.doubleclick.net https://ep2.adtrafficquality.google https://www.google.com",
        "frame-ancestors 'none'",
        "object-src 'none'",
        "base-uri 'self'",
        "form-action 'self'"
      ].join('; ')
    end

    response.headers['Content-Security-Policy'] = csp_policy
  end




end
