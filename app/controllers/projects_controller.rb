class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = "Created new project #{@project.title}"
      redirect_to @project
    else
      render new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    
    if @project.update(project_params)
      flash[:notice] = "Updated project #{@project.title}"
      redirect_to projects_path
    else
      render edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Deleted application"
    redirect_to projects_path
  end

  private

    def project_params
      params.require(:project).permit(:title, :description)
    end
end
