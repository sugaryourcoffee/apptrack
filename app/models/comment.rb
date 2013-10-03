class Comment < ActiveRecord::Base
  belongs_to :track

  validates :title, :comment, presence: true
end
