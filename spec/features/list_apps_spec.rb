require 'spec_helper'

describe "Viewing the list of projects" do

  it "shows the projects" do
    app1 = Project.create(title: "App 1",
                              description: "Desc 1",
                              active: true)
    app2 = Project.create(title: "App 2",
                              description: "Desc 2",
                              active: true)
    app3 = Project.create(title: "App 3",
                              description: "Desc 3",
                              active: false)

    visit projects_url

    expect(page).to have_text(app1.title)
    expect(page).to have_text(app1.description)
    expect(page).to have_text(app2.title)
    expect(page).to have_text(app2.description)
    expect(page).to have_text(app3.title)
    expect(page).to have_text(app3.description)
  end

end
