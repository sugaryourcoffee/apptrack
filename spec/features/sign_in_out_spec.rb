require 'spec_helper'

describe "Sign in" do

  it "should sign in registered user" do
    user = User.create(user_attributes)

    visit signin_path

    expect(page).to have_text("Sign in")
    expect(page).to have_button("Sign in now!")
    expect(page).to have_text("New user? Sign up now!")
    expect(page).to have_link("Sign up now!")

    expect(page).to have_link("Sign in")
    expect(page).not_to have_link("Your Account")
    expect(page).not_to have_link("Sign out")

    fill_in "E-Mail", with: user.email
    fill_in "Password", with: "pa55w0rd"
    click_button "Sign in now!"

    expect(current_path).to eq (user_path(user))
    expect(page).to have_text "You are signed in as #{user.name}"
    expect(page).to have_link user.name
    expect(page).to have_link "Your Account"
    expect(page).to have_link "Sign out"
  end

  it "should not sign in register user without password" do
    user = User.create(user_attributes)

    visit signin_path

    click_button "Sign in now!"

    expect(page).to have_selector("p.notification.error", 
                                  "Invalid email/password combination")
    expect(current_path).to eq sessions_path
  end

  it "should sign out user" do
    user = User.create(user_attributes)

    visit signin_path

    valid_signin user

    expect(current_path).to eq user_path(user)
    expect(page).to have_link "Sign out"

    click_link "Sign out"

    expect(current_path).to eq root_path
    expect(page).to have_link "Sign in"
    expect(page).to have_text "You are signed out now!"
  end

end
