class ChangeContributionIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :contribution_id, :contributor_id
  end
end
