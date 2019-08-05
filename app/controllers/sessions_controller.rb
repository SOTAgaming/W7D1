class SessionsController < ApplicationController  
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new 
    @user = User.new
    render :new
  end 

  def create 
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if @user.nil?
      render :new
      return
    end 
    login(@user)
    redirect_to cats_url
  end 

  def destroy 
    user = current_user
    if user
      user.reset_session_token!
      session[:session_token] = nil
      @current_user = nil 
      redirect_to cats_url
    end
  end
end
