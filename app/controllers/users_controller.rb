class UsersController < ApplicationController
  before_action :redirect_if_logged_in

  def new 
    @user = User.new 
    render :new
  end

  def create 
#    @user = User.new(params[:user][:username], params[:user][:password])
    @user = User.new(user_params)
    
    if @user.save
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
