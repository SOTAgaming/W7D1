class ApplicationController < ActionController::Base

  helper_method :current_user
  

  def redirect_if_logged_in
    if logged_in?
      redirect_to cats_url
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login(user)
    session[:session_token] = user.reset_session_token!
  end 
end
