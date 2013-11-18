class AddFieldsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :category, :string
    add_column :tracks, :sequence, :integer
    add_column :tracks, :status, :string
  end
end
