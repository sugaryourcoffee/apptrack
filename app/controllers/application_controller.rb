class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def signed_in_user
      store_location
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end

end
