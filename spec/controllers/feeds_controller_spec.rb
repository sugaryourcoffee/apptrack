require 'spec_helper'

describe FeedsController do

  let(:user) { User.create!(user_attributes) }
  let(:project) { Project.create!(project_attributes(user: user)) }
  let(:track) { project.tracks.create!(track_attributes(user: user)) }
  let(:comment) { track.comments.create!(comment_attributes(user: user)) }

  describe "after creating new objects" do

    it "should show new feeds for created projects" do
      get :projects, format: :atom
      expect(response.status).to eq(200)
      expect(response).to render_template("projects")
    end

    it "should show new feeds for created tracks"

    it "should show new feeds for created comments"

  end

  describe "after updating objects" do

    before do
      project.update!(description: "Change in project description")
      track.update!(description: "Change in track description")
      comment.update!(comment: "Change in comment description")
    end

    it "should show feeds for updated objects" do
      get :projects, format: :atom
      expect(response.status).to eq(200)
      expect(response).to render_template("projects")
    end

    it "should show feeds for updated tracks"

    it "should show feeds for updated comments"

  end

end
