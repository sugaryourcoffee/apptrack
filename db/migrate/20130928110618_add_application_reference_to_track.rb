class AddApplicationReferenceToTrack < ActiveRecord::Migration
  def change
    add_reference :tracks, :application, index: true
  end
end
