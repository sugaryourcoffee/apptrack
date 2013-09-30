require 'spec_helper'

describe "delete the comment" do

  it "should delete the comment" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes)

    visit project_track_path(app, track)

    click_link "Delete Comment"

    expect(current_path).to eq(project_track_path(app, track))

    expect(page).not_to have_text(comment.title)
  end

end
