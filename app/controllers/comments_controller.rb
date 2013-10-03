class CommentsController < ApplicationController

  def new
    @comment = Comment.new
    @track = Track.find(params[:track_id])
  end

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comments.build(comment_params)

    if @comment.save
      redirect_to project_track_path(@track.project, @track), 
                  notice: "Comment successfully created!"
    else
      render :new
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
      redirect_to project_track_path(@project, @track), 
                  notice: "Comment successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
    @project = @track.project
    @comment.destroy
    redirect_to project_track_path(@project, @track), 
                alert: "Comment successfully deleted!"
  end

  private

    def comment_params
      params.require(:comment).permit(:title, :comment)
    end
end
