require 'spec_helper'

describe "edit track" do

  it "should show the edit page" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit project_track_path(app, track)

    click_link "Edit"

    expect(current_path).to eq(edit_project_track_path(app, track))
  end

  it "should update the track" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit edit_project_track_path(app, track)

    fill_in "Title", with: "Updated track title"
    fill_in "Description", with: "Updated track description"

    click_button "Update Track"

    expect(current_path).to eq(project_track_path(app, track))

    expect(page).to have_text "Track successfully updated!"
    expect(page).to have_text "Updated track title"
    expect(page).to have_text "Updated track description"
  end

  it "should not update the track" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit edit_project_track_path(app, track)

    fill_in "Title", with: " "

    click_button "Update Track"

    expect(current_path).to eq(project_track_path(app, track))

    expect(page).to have_text("error")
  end
end
