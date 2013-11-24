require 'spec_helper'

describe "Viewing the list of projects" do
  let(:user) { User.create(user_attributes) }
  let(:jane) { User.create(user_attributes(name: "Jane",
                                           email: "jane@example.com")) }

  it "shows the projects" do
    app1 = Project.create(title: "App 1",
                          description: "Desc 1",
                          user: user,
                          active: true)
    app2 = Project.create(title: "App 2",
                          description: "Desc 2",
                          user: user,
                          active: true)
    app3 = Project.create(title: "App 3",
                          description: "Desc 3",
                          user: user,
                          active: false)

    visit projects_url

    expect(page).to have_text(app1.title)
    expect(page).to have_text(app1.description)
    expect(page).to have_text(app2.title)
    expect(page).to have_text(app2.description)
    expect(page).to have_text(app3.title)
    expect(page).to have_text(app3.description)
  end

  it "should show contributor" do
    app = Project.create(title: "App",
                         description: "Desc",
                         user: user,
                         contributors: [jane])

    visit projects_url

    expect(page).
      to have_xpath("//img[@alt='Jane' and @title='Project contributor Jane']")
  end

end
