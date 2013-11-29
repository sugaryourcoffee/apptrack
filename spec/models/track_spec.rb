# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  version     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  project_id  :integer
#  user_id     :integer
#  category    :string(255)
#  sequence    :integer
#  status      :string(255)
#

require 'spec_helper'

describe "Track" do

  let(:user) { User.create!(user_attributes) }
  let(:project) { Project.create!(project_attributes(user: user)) }

  it "should respond to attributes" do

    track = Track.new

    expect(track).to respond_to(:title)
    expect(track).to respond_to(:description)
    expect(track).to respond_to(:category)
    expect(track).to respond_to(:status)
    expect(track).to respond_to(:version)
    expect(track).to respond_to(:sequence)
    expect(track).to respond_to(:user)
    expect(track).to respond_to(:comments)

  end

  it "requires a title" do
    track = Track.new(title: " ")

    expect(track.valid?).to be_false
    expect(track.errors[:title].any?).to be_true
  end

  it "requires a description" do
    track = Track.new(description: " ")

    expect(track.valid?).to be_false
    expect(track.errors[:description].any?).to be_true
  end

  it "should delete sequence when not processing" do
    track = project.tracks.create!(track_attributes(sequence: 1, 
                                                status: "Done",
                                                user: user))

    expect(track.sequence).to be_nil
  end

  it "should not delete sequence when processing" do
    track = project.tracks.create!(track_attributes(sequence: 1, 
                                                   status: "Processing",
                                                   user: user))

    expect(track.sequence).to eq 1
  end
end
