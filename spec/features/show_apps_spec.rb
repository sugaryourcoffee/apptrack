require 'spec_helper'

describe "Show project details" do

  it "should show the project" do
    app1 = Project.create(title: "Rendevoux",
                              description: "Meet with others",
                              active: true)

    visit project_url(app1)
    
    expect(page).to have_text(app1.title)
    expect(page).to have_text(app1.description)
    
  end

  it "should show the tracks" do
    app = Project.create(project_attributes)
    app.tracks.create(track_attributes)

    visit project_url(app)

    expect(page).to have_text("#{app.tracks.size} Track")
    expect(page).to have_text(app.tracks[0].title)
    expect(page).to have_text(app.tracks[0].description)
  end
  
end
