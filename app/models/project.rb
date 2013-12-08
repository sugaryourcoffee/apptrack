# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  description    :string(255)
#  active         :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#  url_home       :string(255)
#  url_repository :string(255)
#  url_docs       :string(255)
#  url_test       :string(255)
#  url_staging    :string(255)
#  url_production :string(255)
#

class Project < ActiveRecord::Base
  has_many :tracks, dependent: :destroy
  has_and_belongs_to_many :contributors, class_name: 'User'

  belongs_to :user

  scope :top,
    select("projects.id, count(tracks.id) as tracks_count").
    joins('left join tracks on tracks.project_id = projects.id').
    group("projects.id").
    order("tracks_count DESC")

  validates :title, :description, presence: :true

  after_create :notify_created
  after_update :notify_updated

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

  def self.rank(count)
    ids = top.limit(count).collect { |project| project.id }
    Project.find(ids)
  end

  private
    
    def notify_created
      Notifier.project_added(self).deliver
    end

    def notify_updated
      Notifier.project_updated(self).deliver
    end
end
