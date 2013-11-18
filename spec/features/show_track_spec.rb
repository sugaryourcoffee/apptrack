require 'spec_helper'

describe "Show track details" do
  let(:user) { User.create(user_attributes) }

  it "should show the track" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user,
                                              version: "1.1.1",
                                              category: "Feature",
                                              status: "Open",
                                              sequence: 1))

    visit project_track_path(app, track)

    expect(page).to have_text(track.title)
    expect(page).to have_text(track.description)
    expect(page).to have_text(track.version)
    expect(page).to have_text(track.category)
    expect(page).to have_text(track.status)
    expect(page).to have_text(track.sequence)
  end

  it "should show the comments" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user))
    comment = track.comments.create(comment_attributes(user: user))

    visit project_track_path(app, track)

    expect(page).to have_text(comment.title)
    expect(page).to have_text(comment.comment)
  end

end
