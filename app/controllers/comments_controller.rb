class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    @track = Track.find(params[:track_id])
  end

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comments.create(comment_params)

    if @comment
      flash[:notice] = "Created new comment #{@comment.title}"
      redirect_to project_track_path(@track.project, @track)
    else
      render new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
    @project = @track.project

    if @comment.update(comment_params)
      flash[:notice] = "Updated comment #{@comment.title}"
      redirect_to project_track_path(@project, @track)
    else
      render update
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
    @project = @track.project
    @comment.destroy
    flash[:notice] = "Deleted comment #{@comment.title}"
    redirect_to project_track_path(@project, @track)
  end

  private

    def comment_params
      params.require(:comment).permit(:title, :comment)
    end
end
