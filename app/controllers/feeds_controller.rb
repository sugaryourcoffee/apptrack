class FeedsController < ApplicationController

  def projects
    @projects = Project.order("updated_at, created_at").limit(11)
  end

end
