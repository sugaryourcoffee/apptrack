require 'spec_helper'

describe "Delete user" do
  let!(:user) { User.create(user_attributes) }
  let!(:admin) { User.create(user_attributes(email: "admin@example.com",
                                             name: "admin",
                                             admin: true)) }

  it { expect(User.all.size).to eq 2 }

  describe "by regular user" do
    before do
      valid_signin user
      visit users_path
    end

    it "should not have delete link" do
      expect(page).not_to have_link "Delete" 
    end
  end

  describe "by admin user" do
    before do
      valid_signin admin
      visit users_path
    end

    it "should have delete link on regular user" do
      expect(page).to have_link "Delete"
    end

    it "should delete user" do
      expect { click_link "Delete" }.to change(User, :count).by(-1)
      expect(page).not_to have_text user.name
      expect(page).to have_text admin.name
      expect(page).not_to have_link "Delete"
    end
  end

end
