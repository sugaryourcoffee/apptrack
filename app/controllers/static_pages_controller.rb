class StaticPagesController < ApplicationController
  def home
    @user_count = User.count
    @project_count = Project.count
    @track_count = Track.count
    @comment_count = Comment.count
    @projects = Project.top.limit(10)
  end

  def help
  end

  def about
  end

  def contact
    @message = Message.new(params[:message])
  end

  def message
    @message = Message.new(params[:message])
    unless @message.valid?
      render 'contact'
    else
      Notifier.user_contact(@message).deliver
      redirect_to root_path, notice: 'Your message has been sent!'
    end
  end

  def invite
    @invitation = Invitation.new(params[:invitation])
  end

  def invitation
    @invitation = Invitation.new(params[:invitation])
    unless @invitation.valid?
      render 'invite'
    else
      Notifier.invitation(@invitation).deliver
      redirect_to root_path, 
                  notice: 'Thank you for sending an invitation for apptrack'
                                     
    end
  end

end
