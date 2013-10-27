require 'spec_helper'

describe "edit comment" do
  let(:user) { User.create(user_attributes) }

  before { valid_signin user }

  it "should show the edit page" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes(user: user))

    visit project_track_path(app, track)

    click_link "Edit Comment"

    expect(current_path).to eq(edit_track_comment_path(track, comment))
  end

  it "should update the comment" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes(user: user))

    visit edit_track_comment_path(track, comment)

    fill_in "Title", with: "Updated title"
    fill_in "Comment", with: "Updated comment"

    click_button "Update Comment"

    expect(current_path).to eq(project_track_path(app, track))

    expect(page).to have_text "Comment successfully updated!"
    expect(page).to have_text "Updated title"
    expect(page).to have_text "Updated comment"
  end

  it "should not update the comment" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes(user: user))

    visit edit_track_comment_path(app, track)

    fill_in "Title", with: " "

    click_button "Update Comment"

    expect(current_path).to eq(track_comment_path(app, track))

    expect(page).to have_text("error")
  end

end
