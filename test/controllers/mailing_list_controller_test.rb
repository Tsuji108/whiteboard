require 'test_helper'

class MailingListControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mailing_list_new_url
    assert_response :success
  end

end
