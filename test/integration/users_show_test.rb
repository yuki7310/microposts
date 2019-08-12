require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:archer)
    @other_user = users(:lana)
  end
  
  test "show as correct user including delete links" do 
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    assert_select "a[href=?]", user_path(@user), text: "delete"
    assert @user.activated?
    assert_difference "User.count", -1 do 
      delete user_path(@user)
    end
  end
  
  test "show as wrong user not including delete links" do
    log_in_as(@user)
    get user_path(@other_user)
    assert @other_user.activated?
    assert_select "a[href=?]", user_path(@other_user), text: "delete", count: 0
  end
end
