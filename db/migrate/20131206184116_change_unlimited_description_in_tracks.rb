class ChangeUnlimitedDescriptionInTracks < ActiveRecord::Migration
  def change
    change_column :tracks, :description, :text, limit: nil
  end
end
