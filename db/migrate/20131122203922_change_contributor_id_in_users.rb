class ChangeContributorIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :contributor_id, :contribution_id
  end
end
