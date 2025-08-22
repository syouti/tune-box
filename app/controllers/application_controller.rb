# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  helper_method :current_user, :user_signed_in?, :guest_session_id, :guest_favorite_albums

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end


end
