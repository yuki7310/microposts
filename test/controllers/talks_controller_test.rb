require 'test_helper'

class TalksControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @talk = talks(:talk_0)
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect show when not logged in" do 
    get talk_path(@talk)
    assert_redirected_to login_url
  end
  
  test "should redirect create when not logged in" do 
    post talks_path, params: {member_id: @user.id}
    assert_redirected_to login_url
  end
  
  test "should redirect messages when not logged in" do 
    post messages_talk_path(@talk), params: {message: {user_id: @user.id,
                                                       talk_id: @talk.id,
                                                       content: "test message"}}
    assert_redirected_to login_url
  end
  
  test "should redirect show when not correct_member" do 
    log_in_as(@other_user)
    get talk_path(@talk)
    assert_redirected_to root_url
  end
  
  test "should redirect messages when not correct_member" do 
    log_in_as(@other_user)
    post messages_talk_path(@talk), params: {message: {user_id: @other_user.id,
                                                       talk_id: @talk.id,
                                                       content: "test message"}}
    assert_redirected_to root_url
  end
end
