class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :store_previous_page, only: [:new, :edit]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user, notice: "You have been registered for apptrack!"
    else
      render :new
    end

  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Your account has been successfully updated"
      redirect_back_or @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User has successfully been deleted!"
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email, 
                                   :password, 
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin? and !current_user?(@user)
    end

end
