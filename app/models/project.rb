class Project < ActiveRecord::Base
  has_many :tracks, dependent: :destroy

  validates :title, :description, presence: :true
end
