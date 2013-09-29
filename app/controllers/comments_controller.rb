class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])
    @track = Track.find(params[:track_id])
  end

end
