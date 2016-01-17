# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  comment    :text
#  track_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Comment < ActiveRecord::Base
  belongs_to :track
  belongs_to :user

  validates :title, :comment, presence: true

  scope :by_updated_at, -> { order('updated_at, created_at') }

  after_create :notify_created
  after_update :notify_updated

  def self.recent(count)
    order('updated_at desc').limit(3)
  end

  def track
    Track.find(track_id)
  end

  private

    def notify_created
      Notifier.comment_added(self).deliver
    end

    def notify_updated
      Notifier.comment_updated(self).deliver
    end
end
