require 'spec_helper'

describe "create track" do

  it "should show the new track form" do
    app = Project.create(project_attributes)

    visit project_path(app)

    click_link "Create new Track"

    expect(current_path).to eq(new_project_track_path(app))
  end
  
  it "should create a new track" do
    app = Project.create(project_attributes)

    visit new_project_track_path(app)

    fill_in "Title", with: "New track title"
    fill_in "Description", with: "New track description"

    click_button "Create Track"

    expect(current_path).to eq(project_track_path(app, Track.last))

    expect(page).to have_text("Track successfully created!")
    expect(page).to have_text("New track title")
  end

end
