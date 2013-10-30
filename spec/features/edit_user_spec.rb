require 'spec_helper'

describe "User" do

  it "should update user" do
    user = User.create(user_attributes)

    valid_signin(user)

    visit edit_user_path(user)

    fill_in "Name", with: "Pierre Sugar"
    fill_in "Password", with: "pa55w0rd"
    fill_in "Confirmation", with: "pa55w0rd"

    click_button "Update"

    expect(current_path).to eq user_path(user)
    expect(page).to have_text "Pierre Sugar"
  end

  it "should not update user with invalid password" do
    user = User.create(user_attributes)

    valid_signin(user)

    visit edit_user_path(user)

    fill_in "Name", with: "Pierre Sugar"

    click_button "Update"

    expect(page).to have_text "Password is too short"
    expect(current_path).to eq user_path(user)
  end

  describe "don't allow to update admin attribute", type: :request do
    let(:user) { User.create(user_attributes) }

    let(:params) do
      { user: { admin: true, password: user.password,
                password_confirmation: user.password } }
    end

    before do
      sign_in user, no_capybara: true
      patch user_path(user), params
    end
    specify { expect(user.reload).not_to be_admin }
  end

end
