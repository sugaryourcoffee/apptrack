class RemoveContributionIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :contribution_id
  end
end
