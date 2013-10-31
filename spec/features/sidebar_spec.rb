require 'spec_helper'

describe 'Sidebar' do
  let(:user) { User.create(user_attributes) }

  it "should show recently added users" do
    user = User.create(user_attributes)

    visit root_path

    expect(page).to have_text(user.name)
  end

  it "should show recently added and updated projects" do
    app = Project.create(project_attributes(user: user))

    visit root_path

    expect(page).to have_text(app.title)
  end

  it "should show recently added and updated tracks" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user))

    visit root_path

    expect(page).to have_text(track.title)
  end

  it "should show recently added and updated comments" do
    app = Project.create(project_attributes(user: user))
    track = app.tracks.create(track_attributes(user: user))
    comment = track.comments.create(comment_attributes(user: user))

    visit root_path

    expect(page).to have_text(comment.title)
  end

end
