require 'spec_helper'

describe "List users" do

  let(:user) { User.create(user_attributes) }

  before { valid_signin user }

  it "should list users" do
    visit users_path

    expect(page).to have_text user.name
  end
end
