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
#

class Comment < ActiveRecord::Base
  belongs_to :track

  validates :title, :comment, presence: true

  def self.recent(count)
    order('updated_at desc').limit(3)
  end

  def track
    Track.find(track_id)
  end

end
