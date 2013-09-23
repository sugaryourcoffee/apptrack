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

  
end
