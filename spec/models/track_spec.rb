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
#

require 'spec_helper'

describe "Track" do

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

end
