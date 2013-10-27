class TracksController < ApplicationController

  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :owner,          only: [:edit, :update, :destroy]

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
    @track = @project.tracks.build(track_params)
    @track.user = current_user
    if @track.save
      redirect_to project_track_path(@project, @track), 
                  notice: "Track successfully created!"
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find(params[:project_id])

    if @track.update(track_params)
      redirect_to project_track_path(@project, @track), 
                  notice: "Track successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @track.destroy
    redirect_to project_path(@project), alert: "Track successfully deleted!"
  end

  private

    def track_params
      params.require(:track).permit(:title, :description)
    end

    def owner
      @track = Track.find(params[:id])
      unless current_user?(@track.user)
        flash[:error] = "Sorry, action only alowed by track's owner"
        redirect_to root_url
      end
    end

end
