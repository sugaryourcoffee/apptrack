require 'spec_helper'

describe "Show application details" do

  it "should show the application" do
    app1 = Application.create(title: "Rendevoux",
                              description: "Meet with others",
                              active: true)

    visit application_url(app1)
    
    expect(page).to have_text(app1.title)
    expect(page).to have_text(app1.description)
    
  end

  it "should show the tracks" do
    app = Application.create(application_attributes)
    app.tracks.create(track_attributes)

    visit application_url(app)

    expect(page).to have_text("#{app.tracks.size} Track")
    expect(page).to have_text(app.tracks[0].title)
    expect(page).to have_text(app.tracks[0].description)
  end
  
end
