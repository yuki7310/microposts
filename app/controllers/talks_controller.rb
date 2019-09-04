class TalksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_member, only: [:show, :messages]
  
  def show
    @messages = @talk.messages
    @message = Message.new
  end
  
  def create
    to_user = User.find_by(id: params[:member_id])
    current_user.talks.each do |talk|
      @member = talk.memberships.find_by(user_id: to_user.id)
      redirect_to(talk) and return if @member != nil
    end
    if @member == nil
      @talk = Talk.new
      @talk.memberships.build(user_id: current_user.id)
      @talk.memberships.build(user_id: params[:member_id])
      @talk.save
      redirect_to @talk
    end
  end
  
  def messages
    @message = Message.new(message_params)
    @talk.touch
    if @message.save
      redirect_to @talk
    else
      @messages = @talk.messages
      render "show"
    end
  end
  
  private
  
    def message_params
      params.require(:message).permit(:content).merge(user_id: current_user.id, talk_id: @talk.id)
    end
  
    def correct_member
      @talk = current_user.talks.find_by(id: params[:id])
      redirect_to root_url if @talk.nil?
    end
end
