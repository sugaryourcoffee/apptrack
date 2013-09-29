require 'spec_helper'

describe "edit track" do

  it "should update the track" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit project_track_path(app, track)

    click_link "Edit"

    expect(current_path).to eq(edit_project_track_path(app, track))
  end

end
