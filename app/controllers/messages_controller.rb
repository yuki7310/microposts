class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :update
  
  def update
    @talk = @message.talk
    @message.update!(content: "This message was deleted.")
    flash[:success] = "Message deleted"
    redirect_to @talk
  end
  
  private
    
    def correct_user
      @message = current_user.messages.find_by(id: params[:id])
      redirect_to root_url if @message.nil?
    end
end
