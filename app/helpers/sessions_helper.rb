module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !current_user.nil?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def guest_session_id
    session[:guest_session_id] ||= SecureRandom.hex(16)
  end

  def guest_favorite_albums
    session[:guest_favorites] ||= []
  end
end
