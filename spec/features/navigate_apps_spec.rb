require 'spec_helper'

describe "Navigating projects" do
  let(:user) { User.create(user_attributes) }

  it "should navigate from the detail page to the index page" do
    app = Project.create(project_attributes(user: user))

    visit project_url(app)

    first(:link, "Projects").click

    expect(current_path).to eq(projects_path)

  end

  it "should navigate from the index page to the detail page" do
    app = Project.create(project_attributes(user: user))

    visit projects_url

    first(:link, app.title).click

    expect(current_path).to eq(project_path(app))
  end

  it "should navigate from the detail page to the track page" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(title: "New Feature Track",
                                               user: user))

    visit project_path(app)

    first(:link, track.title).click

    expect(current_path).to eq(project_track_path(app, track))
  end

  it "should navigate from the track page to the detail page" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user))

    visit project_track_path(app, track)

    first(:link, app.title).click

    expect(current_path).to eq(project_path(app))
  end

end
