require 'spec_helper'

describe "Edit app tracks" do
  let(:user) { User.create(user_attributes) }

  it "should change values through links" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user, sequence: 1))

    visit project_url(app)

    expect(page).to have_text(app.tracks[0].sequence)
    expect(page).to have_text(app.tracks[0].title)
    expect(page).to have_text(app.tracks[0].description)
    expect(page).to have_link("sec-up-#{track.id}")
    expect(page).to have_link("sec-down-#{track.id}")
    expect(page).to have_link("status-up-#{track.id}")
    expect(page).to have_link("status-down-#{track.id}")
  end
end
