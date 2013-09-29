class TracksController < ApplicationController

  def show
    @track = Track.find(params[:id])
    @project = Project.find(params[:project_id])
  end

end
