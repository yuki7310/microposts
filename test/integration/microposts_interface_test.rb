require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "microposts interface" do
    log_in_as(@user)
    get root_path
    assert_select "ul.pagination"
    assert_select "input[type=file]"
    # 無効な送信
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select "div#error_explanation"
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content, 
                                                 picture: picture}}
    end
    assert_not flash.empty?
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select "a", text: "delete"
    first_micropost = @user.microposts.page(1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select "a", text: "delete", count: 0
  end
  
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    delete logout_path(@user)
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
  
  test "reply should display on correct feed" do
    from_user = users(:michael)
    to_user = users(:archer)
    follower = users(:lana)
    other_user = users(:malory)
    log_in_as(from_user)
    unique_name = to_user.unique_name
    content = "@#{unique_name} reply test"
    post microposts_path, params: {micropost: {content: content}}
    micropost_id = from_user.microposts.first.id
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content
    delete logout_path
    log_in_as(to_user)
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content
    delete logout_path
    log_in_as(follower)
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content
    delete logout_path
    log_in_as(other_user)
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content, count: 0
  end
end
