require "spec_helper"

describe Notifier do

  let(:user) { User.create(user_attributes) }
  let(:project) { Project.create(project_attributes(user: user)) }
  let(:track) { project.tracks.create(track_attributes(user: user)) }
  let(:comment) { track.comments.create(comment_attributes(user: user)) }

  before do
    @project_body = <<-PROJECT_MAIL
A new project has been added to apptrack\r
\r
Title: #{project.title}\r
Owner: #{user.name}\r
\r
You can view the new project at #{project_url project}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    PROJECT_MAIL

    @track_body = <<-TRACK_MAIL
A new track has been added to project #{project.title} in apptrack\r
\r
Title: #{track.title}\r
Owner: #{user.name}\r
\r
You can view the new track at #{project_track_url project, track}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    TRACK_MAIL

    @comment_body = <<-COMMENT_MAIL
A new comment has been added to the track #{track.title} in the project #{project.title} in apptrack\r
\r
Title: #{comment.title}\r
Owner: #{user.name}\r
\r
You can view the new comment at #{project_track_url project, track}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    COMMENT_MAIL

    @user_body = <<-USER_MAIL
A new user has register for apptrack\r
\r
Name:   #{user.name}\r
E-Mail: #{user.email}\r
\r
You can view the new users profile at #{user_url user}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    USER_MAIL

  end

  describe "project_added" do
    let(:mail) { Notifier.project_added(project) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New Project #{project.title}")
      mail.to.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@project_body)
    end
  end

  describe "track_added" do
    let(:mail) { Notifier.track_added(track) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New Track in Project #{project.title}")
      mail.to.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@track_body)
    end
  end

  describe "comment_added" do
    let(:mail) { Notifier.comment_added(comment) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New Comment in Project #{project.title}")
      mail.to.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@comment_body)
    end
  end

  describe "user_registered" do
    let(:mail) { Notifier.user_registered(user) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New User has registered for apptrack")
      mail.to.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@user_body)
    end
  end
end
