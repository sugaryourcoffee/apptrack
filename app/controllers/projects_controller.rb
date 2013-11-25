class ProjectsController < ApplicationController

  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :owner,          only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @tracks = @project.tracks
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.contributors = User.find(params[:project][:contributors].
                                      reject(&:empty?))
    @project.user = current_user
    if @project.save
      redirect_to @project, notice: "Application successfully created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @project.contributors = User.find(params[:project][:contributors].
                                      reject(&:empty?))

    if @project.update(project_params)
      redirect_to projects_path, notice: "Application successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, alert: "Application successfully deleted!"
  end

  private

    def project_params
      params.require(:project).permit(:title, :description, :active,
                                      :url_home, :url_repository, :url_docs,
                                      :url_test, :url_staging, :url_production)
    end

    def owner
      @project = Project.find(params[:id])
      unless current_user?(@project.user)
        flash[:error] = "Sorry, action alowed only by project's owner"
        redirect_to root_url
      end
    end
end
