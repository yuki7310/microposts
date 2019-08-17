require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
    @other_user = users(:lana)
  end
  
  test "show display" do
    get user_path(@user)
    assert_template "users/show"
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_select "h1>img.gravatar"
    assert_match @user.microposts.count.to_s, response.body
    assert_select "div.pagination"
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_select "span.content", text: micropost.content
    end
  end
  
  test "show as correct user including delete links" do 
    log_in_as(@non_admin)
    get user_path(@non_admin)
    assert_template "users/show"
    assert_select "a[href=?]", user_path(@non_admin), text: "delete"
    assert @non_admin.activated?
    assert_difference "User.count", -1 do 
      delete user_path(@non_admin)
    end
    get user_path(@other_user)
    assert_select "a[href=?]", user_path(@other_user), text: "delete", count: 0
  end
  
end
