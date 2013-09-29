require 'spec_helper'

describe "Show track details" do

  it "should show the track" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit project_track_path(app, track)

    expect(page).to have_text(track.title)
    expect(page).to have_text(track.description)
    expect(page).to have_text(track.version)
  end

  it "should show the comments" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes)

    visit project_track_path(app, track)

    expect(page).to have_text(comment.title)
    expect(page).to have_text(comment.comment)
  end

end
