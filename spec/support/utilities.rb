include ApplicationHelper

def fill_in_credentials(user)
  fill_in "E-Mail",   with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in now!"
end

def valid_signin(user)
  visit signin_path
  fill_in_credentials(user)
end

def sign_in(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    valid_signin(user)
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

