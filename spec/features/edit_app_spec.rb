require 'spec_helper'

describe "edit application" do

  it "should update the application" do
    app = Project.create(project_attributes)

    visit project_path(app)

    click_link "Edit"

    expect(current_path).to eq(edit_project_path(app))

    expect(find_field('Title').value).to eq(app.title)
    
  end

end
