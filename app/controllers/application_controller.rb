# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  helper_method :current_user, :user_signed_in?

  # 基本的なセキュリティヘッダーを追加（機能に影響なし）
  before_action :set_basic_security_headers

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end

  def require_login
    unless user_signed_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end

  # 基本的なセキュリティヘッダー（機能に影響なし）
  def set_basic_security_headers
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
end
