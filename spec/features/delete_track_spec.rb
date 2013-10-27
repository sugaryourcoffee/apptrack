require 'spec_helper'

describe "delete the track" do
  let(:user) { User.create(user_attributes) }

  before { valid_signin(user) }

  it "should delete the track" do
    app = user.projects.create(project_attributes)
    track = app.tracks.create(track_attributes(user: user))

    visit project_track_path(app, track)

    click_link "Delete"

    expect(current_path).to eq(project_path(app))

    expect(page).to have_text("Track successfully deleted!")
    expect(page).not_to have_text(track.title)
  end

end
