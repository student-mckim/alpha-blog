class UsersController < ApplicationController
  before_action :set_user, only: [:show,:edit,:update]
  before_action :require_login, only: [:edit,:update]
  before_action :require_user_permissions, only: [:edit,:update]

  def show 
    # @user = User.new(user_params)
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end
  
  def index
    @users = User.paginate(page: params[:page], per_page: 6)
  end

  def new
    @user = User.new
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Your account has been updated."
      redirect_to @user
    else
      render 'edit'
    end
  end


  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id]= @user.id
      flash[:notice] = "Thanks for signing up #{@user.username}! Welcome."
      redirect_to articles_path
    else
        render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to articles_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_user_permissions
    if current_user != @user
      flash[:alert] = "You can only edit your own account"
      redirect_to @user
    end
  end
end
