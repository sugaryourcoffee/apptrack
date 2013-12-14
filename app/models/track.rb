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
#  user_id     :integer
#  category    :string(255)
#  sequence    :integer
#  status      :string(255)
#

class Track < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many   :comments, dependent: :destroy

  before_save :clear_sequence

  default_scope { order('status DESC').order('sequence ASC') }

  scope :status_stats, ->(the_project_id) {
          group(:status).where('project_id = ?', the_project_id)
        }

  CATEGORY_TYPES = ["Feature", "Issue"]

  STATUS_TYPES = ["Open", "Processing", "Done", "Postponed", "Rejected"]

  validates :title, :description, presence: true
  validates :category, inclusion: CATEGORY_TYPES
  validates :status, inclusion: STATUS_TYPES
  validates :sequence, numericality: { greater_than: 0 }, allow_blank: true

  after_create :notify_created
  after_update :notify_updated

  def self.recent(count)
    order('updated_at desc').limit(count)
  end

  def self.filter(params)
    search_params = params.select { |k,v| not v.empty? and k =~ /^search_/ }
    query_string = "project_id = ?"
    values = [params[:id]]
    unless search_params.empty?
      search_params.each do |k,v|
        query_string << " and "

        key = k.sub("search_", "")

        query_string << "#{key} = ?"
        values << v
      end
    end
    self.where(query_string, *values)
  end

=begin
  def project
    Project.find(project_id)
  end
=end

  private

    def clear_sequence
      self.sequence = nil unless ["Processing", "Open"].include? self.status
    end

    def notify_created
      Notifier.track_added(self).deliver
    end

    def notify_updated
      Notifier.track_updated(self).deliver
    end
end
