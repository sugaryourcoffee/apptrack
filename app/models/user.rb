# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  has_many :projects
  has_many :tracks
  has_many :comments

  has_and_belongs_to_many :contributions, class_name: 'Project'

  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_PATTERN = /\A[\w!#\$%&'*+\/=?`{|}~^-]+(?:\.[\w!#\$%&'*+\/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}\Z/

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token

  after_create :notify_created

  validates :email, presence: true, 
                    format: {with: EMAIL_PATTERN}, 
                    uniqueness: {case_sensitive: false}

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

  def self.find_all_except_for(user)
    self.where("id != :id", id: user.id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def notify_created
      Notifier.user_registered(self).deliver
    end
end
