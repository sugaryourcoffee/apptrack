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
