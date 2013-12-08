class Notifier < ActionMailer::Base
  default from: "apptrack <pierre@sugaryourcoffee.de>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.project_added.subject
  #
  def project_added(project)
    @project = project
    @user   = project.user

    mail to: "pierre@sugaryourcoffee.de",
         subject: "[apptrack] New Project #{@project.title}"
  end

  def project_updated(project)
    @project = project
    @user   = project.user

    mail to: "pierre@sugaryourcoffee.de",
         subject: "[apptrack] Updated Project #{@project.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.track_added.subject
  #
  def track_added(track)
    @project = track.project
    @track   = track
    @user    = @track.user

    mail to: @user.email,
         bcc: "pierre@sugaryourcoffee.de",
         subject: "[apptrack] New Track in Project #{@project.title}"
  end

  def track_updated(track)
    @project = track.project
    @track   = track
    @user    = @track.user

    mail to: @user.email,
         bcc: "pierre@sugaryourcoffee.de",
         subject: "[apptrack] Track updated in Project #{@project.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.comment_added.subject
  #
  def comment_added(comment)
    @comment = comment
    @user    = @comment.user
    @track   = @comment.track
    @project = @track.project

    mail to: @user.email,
         bcc: "pierre@sugaryourcoffee.de, #{@project.user.email}",
         subject: "[apptrack] New Comment in Project #{@project.title}"
  end

  def comment_updated(comment)
    @comment = comment
    @user    = @comment.user
    @track   = @comment.track
    @project = @track.project

    mail to: @user.email,
         bcc: "pierre@sugaryourcoffee.de, #{@project.user.email}",
         subject: "[apptrack] Comment updated in Project #{@project.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.comment_added.subject
  #
  def user_registered(user)
    @user    = user

    mail to: "pierre@sugaryourcoffee.de",
         subject: "[apptrack] New User has registered for apptrack"
  end

  def user_contact(message)
    @message = message

    reciever = ["pierre@sugaryourcoffee.de"] 
    reciever << message.email if message.copy_me
    
    mail from:    message.email,
         to:      reciever.join(','),
         subject: "[apptrack] #{message.subject}"
  end

  def password_reset(user)
    @user = user
    mail to: user.email,
         subject: "[apptrack] Password reset request"
  end

end
