require 'spec_helper'

describe "User signup page" do

  it "should signup user" do
    visit signup_path

    expect(page).to have_text('Sign up')

    fill_in "Name", with: "Pierre"
    fill_in "E-Mail", with: "pierre@sugaryourcoffee.de"
    fill_in "Password", with: "pa55w0rd"
    fill_in "Confirmation", with: "pa55w0rd"

    expect { click_button "Create User" }.to change(User, :count)

    expect(page).to have_text('Pierre')
  end

  it "should not signup user" do
    visit signup_path

    expect(page).to have_text('Sign up')

    fill_in "Name", with: "Pierre"
    fill_in "E-Mail", with: "pierre@sugaryourcoffee.de"

    expect { click_button "Create User" }.not_to change(User, :count)

    expect(current_path).to eq users_path
    expect(page).to have_text "error"
  end
end
