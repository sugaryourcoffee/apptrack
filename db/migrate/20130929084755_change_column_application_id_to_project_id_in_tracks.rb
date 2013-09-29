class ChangeColumnApplicationIdToProjectIdInTracks < ActiveRecord::Migration
  def change
    rename_column :tracks, :application_id, :project_id
  end
end
