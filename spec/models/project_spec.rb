# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe "Project" do
  
  it "requires a title" do
    app = Project.new(title: " ")

    expect(app.valid?).to be_false
    expect(app.errors[:title].any?).to be_true
  end

  it "requires a description" do
    app = Project.new(description: " ")

    expect(app.valid?).to be_false
    expect(app.errors[:description].any?).to be_true
  end

end
