# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  has_many :tracks, dependent: :destroy

  validates :title, :description, presence: :true

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

end
