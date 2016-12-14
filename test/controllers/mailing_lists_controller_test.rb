require 'test_helper'

class MailingListsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mailing_lists_new_url
    assert_response :success
  end

end
