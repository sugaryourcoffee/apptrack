require 'spec_helper'

describe "User show page" do

  it "should show user" do
    user = User.create(user_attributes)

    visit user_path user

    expect(page).to have_text user.name
    expect(page).to have_text user.email

    expect(page).to have_text "0 projects"
    expect(page).to have_text "0 tracks"
    expect(page).to have_text "0 comments"

    expect(page).to have_text "My Profile"
    expect(page).to have_text "You can add your profile at your account"

    expect(page).to have_text "My Projects"
    expect(page).to have_text "You don't have projects yet"
    expect(page).to have_link "Create new project"
    expect(page).to have_text "My Tracks"
    expect(page).to have_text "You don't have tracks yet"
    expect(page).to have_text "My Comments"
    expect(page).to have_text "You don't have comments yet"
  end

  it "should show user's projects" do
    user = User.create(user_attributes)
    project = user.projects.create(project_attributes)

    valid_signin user

    visit user_path user

    expect(page).to have_text project.title
    expect(page).to have_text project.description
    
    expect(page).to have_link "Edit"
    click_link "Edit"
    expect(current_path).to eq edit_project_path(project)

    visit user_path user

    expect(page).to have_link "Show"
    click_link "Show"
    expect(current_path).to eq project_path(project)
  end

  it "should show user's tracks" do
    user = User.create(user_attributes)
    project = Project.create(project_attributes)
    track = project.tracks.create(track_attributes(user: user))

    valid_signin user

    visit user_path user

    expect(page).to have_text track.title
    expect(page).to have_text track.description

    expect(page).to have_link "Edit"
    click_link "Edit"
    expect(current_path).to eq edit_project_track_path(project, track)

    visit user_path user

    expect(page).to have_link "Show"
    click_link "Show"
    expect(current_path).to eq project_track_path(project, track)
  end

  it "should show user's comments" do
    user = User.create(user_attributes)
    project = Project.create(project_attributes)
    track = project.tracks.create(track_attributes)
    comment = track.comments.create(comment_attributes(user: user))

    valid_signin user

    visit user_path user

    expect(page).to have_text comment.title
    expect(page).to have_text comment.comment

    expect(page).to have_link "Edit"
    click_link "Edit"
    expect(current_path).to eq edit_track_comment_path(track, comment)

    visit user_path user

    expect(page).to have_link "Show"
    click_link "Show"
    expect(current_path).to eq project_track_path(track.project, track)
  end

end
