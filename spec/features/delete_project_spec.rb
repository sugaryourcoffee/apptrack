require 'spec_helper'

describe "delete the application" do

  it "should delete the application and show the project listing without the deleted project" do
    app = Project.create(project_attributes)

    visit project_path(app)

    click_link "Delete"

    expect(current_path).to eq(projects_path)

    expect(page).to have_text("Application successfully deleted!")
    expect(page).not_to have_text(app.title)
  end

end
