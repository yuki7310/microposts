require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Microposts"
    assert_equal full_title("Help"), "Help | Microposts"
  end
end