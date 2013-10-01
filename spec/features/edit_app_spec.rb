require 'spec_helper'

describe "edit application" do

  it "should show the edit page" do
    app = Project.create(project_attributes)

    visit project_path(app)

    click_link "Edit"

    expect(current_path).to eq(edit_project_path(app))

    expect(find_field('Title').value).to eq(app.title)
    
  end

  it "should update the application" do
    app = Project.create(project_attributes)

    visit edit_project_path(app)

    fill_in "Title", with: "Updated Apptrack Title"
    fill_in "Description", with: "Manages feature requests and issues"

    click_button "Update Project"

    expect(current_path).to eq(projects_path)

    expect(page).to have_text("Application successfully updated!")
    expect(page).to have_text("Apptrack")
    expect(page).to have_text("feature requests and issues")
  end

end
