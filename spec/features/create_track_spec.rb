require 'spec_helper'

describe "create track" do
  let(:user) { User.create(user_attributes) }

  before { valid_signin(user) }

  it "should show the new track form" do
    app = Project.create(project_attributes(user: user))

    visit project_path(app)

    click_link "Create new Track"

    expect(current_path).to eq(new_project_track_path(app))
  end
  
  it "should create a new track" do
    app = Project.create(project_attributes(user: user))

    visit new_project_track_path(app)

    fill_in "Title", with: "New track title"
    fill_in "Description", with: "New track description"
    fill_in 'Sequence', with: 1
    select  'Feature', from: 'Category'
    select  'Open', from: 'Status'

    click_button "Create Track"

    expect(current_path).to eq(project_track_path(app, Track.last))

    expect(page).to have_text("Track successfully created!")
    expect(page).to have_text("New track title")
    expect(Track.last.user).to eq user
  end

  it "should not create a new track" do
    app = Project.create(project_attributes(user: user))

    visit new_project_track_path(app)

    expect {
      click_button "Create Track"
    }.not_to change(Track, :count)

    expect(page).to have_text("error")
  end

end
