require "spec_helper"

describe Notifier do

  let(:user) { User.create(user_attributes(password_reset_token: 'token')) }
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

    @project_update_body = <<-PROJECT_UPDATE_MAIL
Project has been updated in apptrack\r
\r
Title:  #{project.title}\r
Owner:  #{user.name}\r
\r
You can view the new project at #{project_url project}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    PROJECT_UPDATE_MAIL

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
    
    @track_update_body = <<-TRACK_UPDATE_MAIL
Track has been updated in project #{project.title} in apptrack\r
\r
Title:  #{track.title}\r
Owner:  #{user.name}\r
Status: #{track.status}\r
\r
You can view the new track at #{project_track_url project, track}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    TRACK_UPDATE_MAIL

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

    @comment_update_body = <<-COMMENT_UPDATE_MAIL
Comment has been updated in the track #{track.title} in the project #{project.title} in apptrack\r
\r
Title: #{comment.title}\r
Owner: #{user.name}\r
\r
You can view the new comment at #{project_track_url project, track}\r
\r
Thank you for using apptrack\r
Application Tracking made Easy\r
    COMMENT_UPDATE_MAIL

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

  describe "project_updated" do
    let(:mail) { Notifier.project_updated(project) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] Updated Project #{project.title}")
      mail.to.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@project_update_body)
    end
  end

  describe "track_added" do
    let(:mail) { Notifier.track_added(track) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New Track in Project #{project.title}")
      mail.to.should eq([project.user.email])
      mail.bcc.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@track_body)
    end
  end

  describe "track_updated" do
    let(:mail) { Notifier.track_updated(track) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] Track updated in Project #{project.title}")
      mail.to.should eq([project.user.email])
      mail.bcc.should eq(["pierre@sugaryourcoffee.de"])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@track_update_body)
    end
  end

  describe "comment_added" do
    let(:mail) { Notifier.comment_added(comment) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] New Comment in Project #{project.title}")
      mail.to.should eq([track.user.email])
      mail.bcc.should eq(["pierre@sugaryourcoffee.de", project.user.email])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@comment_body)
    end
  end

  describe "comment_updated" do
    let(:mail) { Notifier.comment_updated(comment) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] Comment updated in Project #{project.title}")
      mail.to.should eq([track.user.email])
      mail.bcc.should eq(["pierre@sugaryourcoffee.de", project.user.email])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@comment_update_body)
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

  describe "password reset sent" do
    let(:mail) { Notifier.password_reset(user) }

    it "renders the headers" do
      mail.subject.should eq("[apptrack] Password reset request")
      mail.to.should eq([user.email])
      mail.from.should eq(["pierre@sugaryourcoffee.de"])
    end

    it "renders the body" do
      mail.body.encoded.
        should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end
