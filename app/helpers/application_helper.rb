module ApplicationHelper
  def logged_in?
    defined?(current_user) && !!current_user
  end
end
