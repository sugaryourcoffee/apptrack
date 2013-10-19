require 'spec_helper'

describe 'Sidebar' do

  it "should show recently added users" do
    user = User.create(user_attributes)

    visit root_path

    expect(page).to have_text(user.name)
  end

  it "should show recently added and updated projects" do
    app = Project.create(project_attributes)

    visit root_path

    expect(page).to have_text(app.title)
  end

  it "should show recently added and updated tracks" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)

    visit root_path

    expect(page).to have_text(track.title)
  end

  it "should show recently added and updated comments" do
    app = Project.create(project_attributes)
    track = app.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes)

    visit root_path

    expect(page).to have_text(comment.title)
  end

end
