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
  belongs_to :user
  has_many   :comments, dependent: :destroy

  default_scope { order('sequence DESC') }

  CATEGORY_TYPES = ["Feature", "Issue"]

  STATUS_TYPES = ["Open", "Processing", "Done", "Postponed", "Rejected"]

  validates :title, :description, presence: true
  validates :category, inclusion: CATEGORY_TYPES
  validates :status, inclusion: STATUS_TYPES
  validates :sequence, numericality: { greater_than: 0 }, allow_blank: true

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

  def project
    Project.find(project_id)
  end
end
