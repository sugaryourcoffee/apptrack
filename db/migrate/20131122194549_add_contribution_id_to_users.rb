class AddContributionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contribution_id, :integer
  end
end
