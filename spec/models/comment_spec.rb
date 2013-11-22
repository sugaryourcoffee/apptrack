# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  comment    :text
#  track_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'spec_helper'

describe "Comment" do

  it "requires a title" do
    comment = Comment.new(title: " ")

    expect(comment.valid?).to be_false
    expect(comment.errors[:title].any?).to be_true
  end

  it "requires a comment" do
    comment = Comment.new(comment: " ")

    expect(comment.valid?).to be_false
    expect(comment.errors[:comment].any?).to be_true
  end

end
