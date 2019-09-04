require 'test_helper'

class TalksInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "talks_interface" do 
    log_in_as(@user)
    get root_path
    assert_select "div#talks-tab ul.pagination"
    get user_path(users(:archer))
    assert_select "div#talks-tab ul.pagination", count: 0
  end
end
