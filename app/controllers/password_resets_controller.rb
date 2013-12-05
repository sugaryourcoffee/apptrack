class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      redirect_to :root, notice: "Password reset instructions have been sent "+
                                 "to your email-address"
    else
      redirect_to :root, notice: "The email address you have provided is not "+
                                 "valid!"
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path,
                  alert: 'Password reset request has been expired'
    elsif @user.update_attributes(user_params)
      redirect_to root_url, notice: 'Password has been reset successfully'
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email, 
                                   :password, 
                                   :password_confirmation)
    end

end
