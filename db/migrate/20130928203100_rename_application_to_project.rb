class RenameApplicationToProject < ActiveRecord::Migration
  def change
    rename_table :applications, :projects
  end
end
