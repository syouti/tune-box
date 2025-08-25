# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  helper_method :current_user, :user_signed_in?, :guest_session_id, :guest_favorite_albums, :guest_user?

  # 基本的なセキュリティヘッダーを追加（機能に影響なし）
  before_action :set_basic_security_headers

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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

  def require_login_or_guest
    # ゲストパラメータがある場合はゲストモードを設定
    session[:guest_mode] = true if params[:guest] == 'true' && !user_signed_in?

    # ログインユーザーまたはゲストモードの場合は許可
    return if user_signed_in? || session[:guest_mode]

    # それ以外の場合はログインページにリダイレクト
    redirect_to login_path, alert: 'ログインしてください'
  end

  # 基本的なセキュリティヘッダー（機能に影響なし）
  def set_basic_security_headers
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
end
