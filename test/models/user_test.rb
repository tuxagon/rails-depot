require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test "old password must be correct to change password" do
    user = users(:one)
    user.old_password = 'wrong'
    assert user.invalid?
    assert_equal ["is incorrect"], user.errors[:old_password]
  end
end
