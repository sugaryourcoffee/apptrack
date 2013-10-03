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
