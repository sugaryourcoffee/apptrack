class AddContributorIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contributor_id, :integer
  end
end
