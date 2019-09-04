require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  
  def setup
    @talk = talks(:talk_0)
    @user = users(:archer)
    @membership = @talk.memberships.build(user: @user)
  end
  
  test "should be valid" do
    assert @membership.valid?
  end
  
  test "user_id should be present" do
    @membership.user_id = nil
    assert_not @membership.valid?
  end
  
  test "combination of talk_id and user_id should be unique" do
    @membership.save
    dup = @membership.dup
    assert_not dup.valid?
  end

  
end
