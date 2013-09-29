class Track < ActiveRecord::Base
  belongs_to :project
  has_many   :comments, dependent: :destroy

  def project
    Project.find(project_id)
  end
end
