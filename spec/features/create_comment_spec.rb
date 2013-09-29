require 'spec_helper'

describe "create comment" do

  it "should show new comment form" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit project_track_path(app, track)

    click_link "Create new Comment"

    expect(current_path).to eq(new_track_comment_path(track))
  end

  it "should create a new comment" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit new_track_comment_path(track)

    fill_in "Title", with: "New comment title"
    fill_in "Comment", with: "New comment"

    click_button "Create Comment"

    expect(current_path).to eq(project_track_path(app, track))

    expect(page).to have_text "New comment title"
  end

end
