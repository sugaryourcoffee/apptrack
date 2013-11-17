require 'spec_helper'

describe "Create Application" do
  let(:user) { User.create(user_attributes) }

  before { valid_signin(user) }

  it "should show new application form" do
    visit projects_path

    click_link "Create new Project"

    expect(current_path).to eq(new_project_path)
  end

  it "should create the new application" do
    visit new_project_path

    fill_in "Title", with: "New application title"
    fill_in "Description", with: "New application description"
    check   "Active"
    fill_in "Homepage", with: "home.example.com"
    fill_in "Source Code", with: "source.example.com"
    fill_in "Docs", with: "docs.example.com"
    fill_in "Test Server", with: "test.example.com"
    fill_in "Staging Server", with: "staging.example.com"
    fill_in "Production Server", with: "production.example.com" 

    click_button "Create Project"

    expect(current_path).to eq(project_path(Project.last))
    expect(page).to have_text "Application successfully created!"
    expect(page).to have_text "New application title"
    expect(page).to have_link "Homepage"
    expect(page).to have_link "Source Code"
    expect(page).to have_link "Docs"
    expect(page).to have_link "Test Server"
    expect(page).to have_link "Staging Server"
    expect(page).to have_link "Production Server"
    expect(Project.last.user).to eq user
  end

  it "should not create an application without required attributes" do
    visit new_project_path

    fill_in "Title", with: " "
    fill_in "Description", with: "A description of the new application"

    expect {
      click_button "Create Project"
    }.not_to change(Project, :count)

    expect(current_path).to eq(projects_path)
    expect(page).to have_text("error")
  end
end
