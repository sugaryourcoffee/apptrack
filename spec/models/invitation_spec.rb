require 'spec_helper'

describe 'Invitation' do
  
  it "should respond to attributes" do
    invitation = Invitation.new(invitation_attributes)

    expect(invitation).to respond_to(:attributes)
  end

  it "should not be valid with attributes nil" do
    invitation = Invitation.new nil

    expect(invitation.valid?).to be_false
    expect(invitation.errors.any?).to be_true
  end

  it "should not be valid with empty attributes" do
    invitation = Invitation.new

    expect(invitation.valid?).to be_false
    expect(invitation.errors.any?).to be_true
  end

  it "should have a sender" do
    invitation = Invitation.new(invitation_attributes(email: ""))

    expect(invitation.valid?).to be_false
    expect(invitation.errors[:email].any?).to be_true
  end

  it "recipients should not be empty" do
    invitation = Invitation.new(invitation_attributes(recipients: ""))

    expect(invitation.valid?).to be_false
    expect(invitation.errors[:recipients].any?).to be_true
  end

  it "recipients should have valid email addresses" do
    invitation = Invitation.new(invitation_attributes(recipients: "p@s.de, a"))

    expect(invitation.valid?).to be_false
    expect(invitation.errors[:recipients].any?).to be_true
  end

  it "should have a subject" do
    invitation = Invitation.new(invitation_attributes(subject: " "))

    expect(invitation.valid?).to be_false
    expect(invitation.errors[:subject].any?).to be_true
  end

  it "should have a message" do
    invitation = Invitation.new(invitation_attributes(message: " "))

    expect(invitation.valid?).to be_false
    expect(invitation.errors[:message].any?).to be_true
  end
end
