class Track < ActiveRecord::Base
  belongs_to :application
  has_many   :comments, dependent: :destroy
end
