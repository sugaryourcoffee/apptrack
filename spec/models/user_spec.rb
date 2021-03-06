# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  
  it "should respond to attributes" do
    user = User.new(user_attributes)

    expect(user).to respond_to(:name)
    expect(user).to respond_to(:email)
    expect(user).to respond_to(:password_digest)
    expect(user).to respond_to(:password)
    expect(user).to respond_to(:password_confirmation)
    expect(user).to respond_to(:authenticate)
    expect(user).to respond_to(:remember_token)
    expect(user).to respond_to(:admin)
    expect(user).to respond_to(:contributions)
    expect(user).to respond_to(:password_reset_token)
    expect(user).to respond_to(:password_reset_sent_at)
  end

  it "should not be admin as default user" do
    user = User.new(user_attributes)

    expect(user).not_to be_admin
  end

  it "should be admin with admin attribute set to true" do
    user = User.new(user_attributes)
    user.toggle!(:admin)

    expect(user).to be_admin
  end

  it "requires a name" do
    user = User.new(user_attributes(name: ""))

    expect(user).not_to be_valid
    expect(user.errors[:name].any?).to be_true
  end

  it "should be valid when password and confirmation are non-empty and match" do
    user = User.new(user_attributes)

    expect(user).to be_valid
    expect(user.errors[:password].any?).to be_false
    expect(user.errors[:password_confirmation].any?).to be_false
  end

  it "should have a non empty remember token" do
    user = User.new(user_attributes)

    expect { user.save }.to change(User, :count).by(1) 
    expect(user.remember_token).not_to be_blank
  end

  it "should not be valid when password and confirmation are empty" do
    user = User.new(user_attributes(password: " ", password_confirmation: " "))

    expect(user).not_to be_valid
    expect(user.errors[:password].any?).to be_true
  end

  it "should not be valid when password and confirmation are different" do
    user = User.new(user_attributes(password: "password",
                                    password_confirmation: "pa55w0rd"))

    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation].any?).to be_true
  end
    
  it "should not be valid when password confirmation is nil" do
    user = User.new(user_attributes(password_confirmation: nil))

    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation].any?).to be_true
  end

  it "should only authenticate with valid password" do
    user = User.create(user_attributes)

    found_user = User.find_by(email: user.email)
    
    expect(user).to eq found_user.authenticate(user.password)
  end

  it "should not authenticate with invalid password" do
    user = User.create(user_attributes)

    found_user = User.find_by(email: user.email)

    expect(user).not_to eq found_user.authenticate("invalid")
    expect(found_user.authenticate("invalid")).to be_false
  end

  it "should accept only passwords with a minimum of 6 characters" do
    user = User.new(user_attributes(password: "12345",
                                    password_confirmation: "12345"))

    expect(user).not_to be_valid
    expect(user.errors[:password].any?).to be_true
  end

  it "should accept valid email addresses" do
    user = User.new(user_attributes)

    emails = %w[a@b.de abc-de@fgh-i.com wi_be@ac.COM]

    emails.each do |email|
      user.email = email
      expect(user).to be_valid
      expect(user.errors[:email].any?).to be_false
    end
  end

  it "should not accept invalid email addresses" do
    user = User.new(user_attributes)

    emails = %w[@b.de a@b. a"c@b.de abc@de.c ab@c+b.de]

    emails.each do |email|
      user.email = email
      expect(user).not_to be_valid
      expect(user.errors[:email].any?).to be_true
    end
  end

  it "should not accept taken email address" do
    user = User.create(user_attributes)
    another_user = user.dup

    expect(another_user.save).to be_false
    expect(another_user.errors[:email].any?).to be_true

    another_user.email = user.email.upcase

    expect(another_user.save).to be_false
    expect(another_user.errors[:email].any?).to be_true
  end

  describe "#send_password_reset" do
    let(:user) { User.create(user_attributes) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      expect(user.password_reset_token).not_to eq last_token
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      expect(user.reload.password_reset_sent_at).to be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      expect(last_email.to).to include user.email
    end
  end
end
