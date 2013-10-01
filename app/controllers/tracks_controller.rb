class TracksController < ApplicationController

  def show
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def new
    @track = Track.new
    @project = Project.find(params[:project_id])
  end

  def create
    @project = Project.find(params[:project_id])
    @track = @project.tracks.create(track_params)
    if @track
      redirect_to project_track_path(@project, @track), 
                  notice: "Track successfully created!"
    else
      render new
    end
  end

  def edit
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def update
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])

    if @track.update(track_params)
      redirect_to project_track_path(@project, @track), 
                  notice: "Track successfully updated!"
    else
      render update
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to project_path(@project), alert: "Track successfully deleted!"
  end

  private

    def track_params
      params.require(:track).permit(:title, :description)
    end

end
