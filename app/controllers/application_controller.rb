class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

end
