class FeedsController < ApplicationController

  def projects
    @projects = Project.order("updated_at, created_at").limit(11)
  end

  def tracks
    @tracks = Track.order("updated_at, created_at").limit(11)
  end

  def comments
    @comments = Comment.order("updated_at, created_at").limit(11)
  end

end
