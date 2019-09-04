require 'test_helper'

class MessagesInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @talk = @user.talks.first
  end
  
  test "messages_interface" do 
    log_in_as(@user)
    get talk_path(@talk)
    assert_no_difference "Message.count" do
      post messages_talk_path(@talk), params: {message: {user: nil, 
                                                         content: ""}}
    end
    assert_select "div#error_explanation"
    content = "test message"
    assert_difference "Message.count", 1 do
      post messages_talk_path(@talk), params: {message: {user: @user, 
                                                         content: content}}
    end
    assert_redirected_to @talk
    follow_redirect!
    assert_match content, response.body
    assert_select "a", text: "delete"
    first_message = @talk.messages.find_by(user: @user)
    patch message_path(first_message)
    assert_redirected_to @talk
    follow_redirect!
    assert_select "span.content", text: "This message was deleted."
  end
end
