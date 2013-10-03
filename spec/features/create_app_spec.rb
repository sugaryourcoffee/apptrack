require 'spec_helper'

describe "Create Application" do

  it "should show new application form" do
    visit projects_path

    click_link "Create new Project"

    expect(current_path).to eq(new_project_path)
  end

  it "should create the new application" do
    visit new_project_path

    fill_in "Title", with: "New application title"
    fill_in "Description", with: "New application description"

    click_button "Create Project"

    expect(current_path).to eq(project_path(Project.last))
    expect(page).to have_text "Application successfully created!"
    expect(page).to have_text "New application title"
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
