require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  def setup
    @talk = talks(:talk_0)
    @user = @talk.members.first
    @message = @talk.messages.create(user: @user, content: "test")
  end
  
  test "should be valid" do
    assert @message.valid?
  end
  
  test "user_id should be present" do 
    @message.user_id = nil
    assert_not @message.valid?
  end
  
  test "talk_id should be present" do 
    @message.talk_id = nil
    assert_not @message.valid?
  end
  
  test "content should be at most 140 characters" do
    @message.content = "a" * 141
    assert_not @message.valid?
  end

end
