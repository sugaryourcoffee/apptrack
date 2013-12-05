require 'spec_helper'

describe "PasswordResets" do
  let(:user) { User.create(user_attributes) }

  it "should send user password reset link" do
    visit signin_path
    click_link 'Reset password'
    fill_in 'Enter your email', with: user.email
    click_button 'Send'
    expect(current_path).to eq root_path
    expect(page).to have_content("Password reset instructions")
    last_email.to.should include(user.email)
  end

  it "should not send user password reset link with unknown email address" do
    visit signin_path
    click_link 'Reset password'
    fill_in 'Enter your email', with: 'wrong@example.com'
    click_button 'Send'
    expect(current_path).to eq root_path
    expect(page).to have_content("The email address you have provided is "+
                                 "not valid")
    expect(last_email).to be_nil
  end

  it "should reset password" do
    visit signin_path
    click_link 'Reset password'
    fill_in 'Enter your email', with: user.email
    click_button 'Send'
    visit edit_password_reset_url(user.reload.password_reset_token)
    fill_in 'Password', with: 'pa55w0rd'
    fill_in 'Password confirmation', with: 'pa55w0rd'
    click_button 'Update Password'
    expect(page).to have_content("Password has been reset successfully")
  end

  it "should not reset password when reset time has expired" do
    visit signin_path
    click_link 'Reset password'
    fill_in 'Enter your email', with: user.email
    click_button 'Send'
    user.password_reset_sent_at = 3.hours.ago
    user.save!
    visit edit_password_reset_url(user.reload.password_reset_token)
    fill_in 'Password', with: 'pa55w0rd'
    fill_in 'Password confirmation', with: 'pa55w0rd'
    click_button 'Update Password'
    expect(page).to have_content("Password reset request")
  end
end
