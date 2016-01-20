class TracksController < ApplicationController

  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :owner,          only: [:edit, :update, :destroy, :sec_up,
                                        :sec_down, :status_up, :status_down]
  before_action :store_previous_page, only: [:new, :edit]

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
      flash[:notice] = 'Track successfully updated!'
      redirect_back_or project_track_path(@project, @track)
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @track.destroy
    redirect_to project_path(@project), alert: "Track successfully deleted!"
  end

  def sec_up
    load_project
    track_sequence(1)
  end

  def sec_down
    load_project
    track_sequence(-1) or redirect_to @project, 
                                    alert: "Could not update sequence!"
  end

  def status_up
    load_project
    track_status(1) or redirect_to @project,
                                    alert: "Could not update status!"
  end

  def status_down
    load_project
    track_status(-1) or redirect_to @project,
                                    alert: "Could not update status!"
  end

  private

    def track_sequence(inc)
      track_sequence = (@track.sequence || 0) + inc
      @track.sequence = (track_sequence < 1 ? nil : track_sequence)
      if @track.save
        redirect_to @project 
      end
    end

    def track_status(inc)
      status_count = Track::STATUS_TYPES.count
      index = Track::STATUS_TYPES.index(@track.status) + inc
      index = case index
              when -1
                status_count - 1
              when status_count
                0
              else
                index
              end
      @track.status = Track::STATUS_TYPES[index]
      if @track.save
        respond_to do |format|
          format.html
          format.js { redirect_to @project }
        end
      end
    end

    def load_project
      @project = Project.find(params[:project_id])
    end
    
    def track_params
      params.require(:track).permit(:title, :description, :version, 
                                    :category, :status, :sequence)
    end

    def owner
      @track = Track.find(params[:id])
      unless current_user?(@track.user)
        flash[:error] = "Sorry, action only alowed by track's owner"
        redirect_to root_url
      end
    end

end
