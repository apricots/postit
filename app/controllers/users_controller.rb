class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      flash[:notice] = "Hi #{@user.username}! You have created a new account!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end

  end

  def show

  end


  def edit

  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your information has been saved."
      @user = current_user
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def set_user
    @user = User.find_by slug: (params[:id])
  end

  # can only edit or update own profile
  def require_same_user
    if current_user != @user
      flash[:error] = "You are not allowed to do that."
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end