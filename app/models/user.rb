# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  has_many :projects
  has_many :tracks
  has_many :comments

  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_PATTERN = /\A[\w!#\$%&'*+\/=?`{|}~^-]+(?:\.[\w!#\$%&'*+\/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}\Z/
  before_save { |user| user.email = email.downcase }
  validates :email, presence: true, 
                    format: {with: EMAIL_PATTERN}, 
                    uniqueness: {case_sensitive: false}

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

end
