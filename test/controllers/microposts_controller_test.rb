require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
  end
  
  test "should redirect create when not logged in" do 
    assert_no_difference "User.count" do
      post microposts_path, params: {micropost: {content: "Lorem"}}
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do 
    assert_no_difference "User.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
  
  test "in_reply_to should include to_user unique_name when reply" do
    from_user = users(:michael)
    log_in_as(from_user)
    to_user = users(:archer)
    unique_name = to_user.unique_name
    content = "@#{unique_name} reply test"
    post microposts_path, params: {micropost: {content: content}}
    assert_equal to_user.id, Micropost.first.in_reply_to
  end

end
