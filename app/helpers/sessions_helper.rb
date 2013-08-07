module SessionsHelper

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
    self.current_user.update_attribute(:last_sign_in, Time.now)
  end

  def sign_out
    reset_session
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate!
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to root_path, notice: "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
