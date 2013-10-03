class Track < ActiveRecord::Base
  belongs_to :project
  has_many   :comments, dependent: :destroy

  validates :title, :description, presence: true

  def project
    Project.find(project_id)
  end
end
