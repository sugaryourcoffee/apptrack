require 'spec_helper'

describe "edit comment" do

  it "should update comment" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes)

    visit project_track_path(app, track)

    click_link "Edit Comment"

    expect(current_path).to eq(edit_track_comment_path(track, comment))
  end

end
