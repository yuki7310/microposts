require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @message = messages(:message_0)
    @wrong_user = users(:archer)
  end
  
  test "should redirect update when not logged in" do 
    patch message_path(@message)
    assert_redirected_to login_url
  end
  
  test "should redirect update when not correct_user" do
    log_in_as(@wrong_user)
    patch message_path(@message)
    assert_redirected_to root_url
  end
end
