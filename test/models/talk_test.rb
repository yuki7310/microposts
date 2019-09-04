require 'test_helper'

class TalkTest < ActiveSupport::TestCase
  
  def setup
    @talk = Talk.create
    10.times do |t|
      user = users("user_#{t}".to_sym)
      @talk.memberships.create(user: user)
      @talk.messages.create(user: user, content: Faker::Lorem.sentence(5))
    end
  end
  
  test "assosiated memberships should be destroyed" do
    assert_difference "Membership.count", -10 do
      @talk.destroy
    end
  end
  
  test "assosiated messages should be destroyed" do
    assert_difference "Message.count", -10 do
      @talk.destroy
    end
  end
end
