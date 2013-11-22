class RemoveContributorIdFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :contributor_id
  end
end
