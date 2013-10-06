# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  version     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  project_id  :integer
#

class Track < ActiveRecord::Base
  belongs_to :project
  has_many   :comments, dependent: :destroy

  validates :title, :description, presence: true

  def project
    Project.find(project_id)
  end
end
