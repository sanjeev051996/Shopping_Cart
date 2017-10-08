module UsersSession

  def log_in(user)
    session[:user_id] = user.id
    session[:times_visited] ||= 0
    session[:times_visited] += 1
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) rescue nil
  end
end
