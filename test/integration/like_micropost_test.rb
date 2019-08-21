require 'test_helper'

class LikeMicropostTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @micropost = microposts(:van)
    log_in_as(@user)
  end
  
  test "should like a micropost the standard way" do
    assert_difference "@micropost.like_users.count", 1 do
      post likes_path, params: {micropost_id: @micropost.id}
    end
  end
  
  test "should like a micropost with Ajax" do
    assert_difference "@micropost.likes.count", 1 do
      post likes_path, params: {micropost_id: @micropost.id}, xhr: true
    end
  end
  
  test "should unlike a micropost the standard way" do
    @micropost.like(@user)
    like = @micropost.likes.find_by(user_id: @user.id)
    assert_difference "@micropost.like_users.count", -1 do
      delete like_path(like)
    end
  end
  
  test "should unlike a micropost with Ajax" do
    @micropost.like(@user)
    like = @micropost.likes.find_by(user_id: @user.id)
    assert_difference "@micropost.like_users.count", -1 do
      delete like_path(like), xhr: true
    end
  end
end
