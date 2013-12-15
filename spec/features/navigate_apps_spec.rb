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
  
  describe "cancel button in new and edit pages" do
    let!(:app) { Project.create!(project_attributes(user: user)) }

    before { valid_signin user }

    it "should return from new page to projects page" do
      visit projects_path

      click_link 'Create new Project'
      expect(current_path).to eq new_project_path

      click_link 'Cancel'
      expect(current_path).to eq projects_path
    end

    it "should return from new page to projects page after invalid input" do
      visit projects_path

      click_link 'Create new Project'
      expect(current_path).to eq new_project_path

      click_button 'Create Project'
      click_link 'Cancel'
      expect(current_path).to eq projects_path
    end

    it "should return from new page to project page" do
      visit project_path(app)

      click_link 'Create new Project'
      expect(current_path).to eq new_project_path

      click_link 'Cancel'
      expect(current_path).to eq project_path(app)
    end

    it "should return from new page to project page after invalid input" do
      visit project_path(app)

      click_link 'Create new Project'
      expect(current_path).to eq new_project_path

      click_button 'Create Project'
      click_link 'Cancel'
      expect(current_path).to eq project_path(app)
    end

    it "should return from edit page to projects page" do
      visit projects_path
      expect(page).to have_text app.description

      click_link 'Edit'
      expect(current_path).to eq edit_project_path(app)

      click_link 'Cancel'
      expect(current_path).to eq projects_path
    end
    
    it "should return form edit page to project page" do
      visit project_path(app)
      expect(page).to have_text app.description

      click_link 'Edit'
      expect(current_path).to eq edit_project_path(app)

      click_link 'Cancel'
      expect(current_path).to eq project_path(app)
    end

  end

end

describe 'Navigating Tasks' do
  let(:user) { User.create!(user_attributes) }

  describe "cancel button in new and edit pages" do
    let!(:app) { Project.create!(project_attributes(user: user)) }
    let!(:track) { app.tracks.create!(track_attributes(user: user)) }

    before { valid_signin user }

    it "should return from new page to project page" do
      visit project_path(app)

      click_link 'Create new Track'
      expect(current_path).to eq new_project_track_path(app)

      click_link 'Cancel'
      expect(current_path).to eq project_path(app)
    end

    it "should return from new page to project page after invalid input" do
      visit project_path(app)

      click_link 'Create new Track'
      expect(current_path).to eq new_project_track_path(app)

      click_button 'Create Track'
      click_link 'Cancel'
      expect(current_path).to eq project_path(app)
    end

    it "should return from new page to track page" do
      visit project_track_path(app, track)

      click_link 'Create new Track'
      expect(current_path).to eq new_project_track_path(app)

      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end

    it "should return from new page to track page after invalid input" do
      visit project_track_path(app, track)

      click_link 'Create new Track'
      expect(current_path).to eq new_project_track_path(app)

      click_button 'Create Track'
      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end

    it "should return from edit page to track page" do
      visit project_track_path(app, track)
      
      expect(page).to have_text(track.description)

      click_link 'Edit'
      expect(current_path).to eq edit_project_track_path(app, track)

      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end

  end
end

describe 'Navigating Comments' do
  let(:user) { User.create!(user_attributes) }

  describe "cancel button in new and edit pages" do

    let!(:app) { Project.create!(project_attributes(user: user)) }
    let!(:track) { app.tracks.create!(track_attributes(user: user)) }
    let!(:comment) { track.comments.create!(comment_attributes(user: user)) }

    before { valid_signin user }

    it "should return from new page to track page" do
      visit project_track_path(app, track)

      click_link 'Create new Comment'
      expect(current_path).to eq new_track_comment_path(track)

      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end

    it "should return from new page to track page after invalid input" do
      visit project_track_path(app, track)

      click_link 'Create new Comment'
      expect(current_path).to eq new_track_comment_path(track)

      click_button 'Create Comment'
      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end

    it "should return from edit page to track page" do
      visit project_track_path(app, track)

      click_link 'Edit Comment'
      expect(current_path).to eq edit_track_comment_path(track, comment)

      click_link 'Cancel'
      expect(current_path).to eq project_track_path(app, track)
    end
  end
end

describe 'Navigation users' do
  let(:user) { User.create(user_attributes) }

  describe 'cancel button in new and edit pages' do

    it "should return from new page to home page" do
      visit root_path
      
      click_link 'Sign up now!'
      expect(current_path).to eq signup_path
      
      click_link 'Cancel'
      expect(current_path).to eq root_path
    end

    it "should return from new page to home page after invalid input" do
      visit root_path

      click_link 'Sign up now!'
      expect(current_path).to eq signup_path

      click_button 'Create User'
      click_link 'Cancel'
      expect(current_path).to eq root_path
    end

    it "should return from edit page to home page" do
      valid_signin user

      visit root_path

      click_link '[Your Account]'
      expect(current_path).to eq edit_user_path(user)

      click_link 'Cancel'
      expect(current_path).to eq root_path
    end

    it "should return from edit page to home page after invalid input" do
      valid_signin user

      visit root_path

      click_link '[Your Account]'
      expect(current_path).to eq edit_user_path(user)

      click_button 'Update User'
      click_link 'Cancel'
      expect(current_path).to eq root_path
    end
  end
end
