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
  
  it "should respond to attributes" do
    app = Project.new

    expect(app).to respond_to(:title)
    expect(app).to respond_to(:description)
    expect(app).to respond_to(:user)
    expect(app).to respond_to(:tracks)
    expect(app).to respond_to(:active)
    expect(app).to respond_to(:url_home)
    expect(app).to respond_to(:url_repository)
    expect(app).to respond_to(:url_docs)
    expect(app).to respond_to(:url_test)
    expect(app).to respond_to(:url_staging)
    expect(app).to respond_to(:url_production)
  end
  
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
