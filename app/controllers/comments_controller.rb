class CommentsController < ApplicationController

  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :owner,          only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
    @track = Track.find(params[:track_id])
    @project = @track.project
  end

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comments.build(comment_params)
    @comment.user = current_user
    @project = @track.project

    if @comment.save
      redirect_to project_track_path(@track.project, @track), 
                  notice: "Comment successfully created!"
    else
      render :new
    end
  end

  def edit
    @track = Track.find(params[:track_id])
    @project = @track.project
  end

  def update
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

    def owner
      @comment = Comment.find(params[:id])
      unless current_user?(@comment.user)
        flash[:error] = "Sorry, action only alowed by comment's owner"
        redirect_to root_url
      end
    end
end
