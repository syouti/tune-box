# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  helper_method :current_user, :user_signed_in?, :guest_session_id, :guest_favorite_albums, :guest_user?

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


end
