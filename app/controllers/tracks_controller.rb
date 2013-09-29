class TracksController < ApplicationController

  def show
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def edit
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def update
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])

    if @track.update(track_params)
      flash[:notice] = "Updated track #{@track.title}"
      redirect_to project_track_path(@project, @track)
    else
      render update
    end
  end

  private

    def track_params
      params.require(:track).permit(:title, :description)
    end

end
