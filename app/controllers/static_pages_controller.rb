class StaticPagesController < ApplicationController
  def home
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

end
