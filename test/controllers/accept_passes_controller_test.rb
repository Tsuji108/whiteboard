require 'test_helper'

class AcceptPassesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get accept_passes_edit_url
    assert_response :success
  end

end
