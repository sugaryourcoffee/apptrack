require 'spec_helper'

describe "Filter tracks" do
  let(:user) { User.create(user_attributes) }
  let(:app)  { Project.create(project_attributes(user: user)) }

  before do 
    valid_signin user 
    app.tracks.create { track_attributes(title: "Track 1",
                                         status: "Open",
                                         category: "Issue") }
    app.tracks.create { track_attributes(title: "Track 2",
                                         status: "Processing",
                                         category: "Issue") } 
    visit project_path(app)
  end

  it "should list all tracks" do
  end

  it "should list filtered tracks" do
    select '1', from: 'Sequence'
    select 'Open', from: 'Status'
    select 'Issue', from: 'Category'

    click_button 'Filter'

    expect(page).not_to have_text('Track 2')
  end

end
