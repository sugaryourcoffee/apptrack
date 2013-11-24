require 'spec_helper'

describe "edit application" do
  let(:user) { User.create(user_attributes) }
  let!(:john) { User.create(user_attributes(name: 'John', email: 'john@example.com')) }
  let!(:jane) { User.create(user_attributes(name: 'Jane', email: 'jane@example.com')) }


  before { valid_signin(user) }

  it "should show the edit page" do
    app = user.projects.create(project_attributes)

    visit project_path(app)

    click_link "Edit"

    expect(current_path).to eq(edit_project_path(app))

    expect(find_field('Title').value).to eq(app.title)
    
  end

  it "should update the application" do
    app = user.projects.create(project_attributes)

    visit edit_project_path(app)

    fill_in "Title", with: "Updated Apptrack Title"
    fill_in "Description", with: "Manages feature requests and issues"

    click_button "Update Project"

    expect(current_path).to eq(projects_path)

    expect(page).to have_text("Application successfully updated!")
    expect(page).to have_text("Apptrack")
    expect(page).to have_text("feature requests and issues")
  end

  it "should add contributors" do
    app = user.projects.create(project_attributes)

    visit edit_project_path(app)

    select john.email, from: 'Contributors'
    select jane.email, from: 'Contributors'
 
    click_button "Update Project"

    expect(current_path).to eq(projects_path)

    expect(page).to have_text("Application successfully updated!")
    expect(app.contributors.size).to eq 2
  end

  it "should remove contributors" do
    app = user.projects.create(project_attributes(contributors: [jane, john]))

    expect(app.contributors.size).to eq 2

    visit edit_project_path(app)

    click_button "Update Project"

    expect(current_path).to eq(projects_path)

    expect(page).to have_text("Application successfully updated!")
    expect(app.reload.contributors.size).to eq 0
  end

  it "should not update the application" do
    app = user.projects.create(project_attributes)

    visit edit_project_path(app)

    fill_in "Title", with: " "

    click_button "Update Project"

    expect(current_path).to eq(project_path(app))
    expect(page).to have_text("error")
  end

end
