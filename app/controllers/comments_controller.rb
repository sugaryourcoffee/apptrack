class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
    @project = Project.find(@track.project_id)

    if @comment.update(comment_params)
      flash[:notice] = "Updated comment #{@comment.title}"
      redirect_to project_track_path(@project, @track)
    else
      render update
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:title, :comment)
    end
end
