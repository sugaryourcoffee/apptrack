class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
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

  private

    def project_params
      params.require(:project).permit(:title, :description)
    end
end
