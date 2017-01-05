require 'test_helper'

class MailingListsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user            = users(:ito)
    @other_user      = users(:soneda)
    @non_active_user = users(:non_active_user)

    @mailing_list_one = mailing_lists(:one)
    @mailing_list_two = mailing_lists(:two)
    log_in_as(@user)
  end

  test 'should get new when logged in as valid user' do
    get new_user_mailing_list_path(@user)
    assert_response :success
  end

  test 'should get index when logged in as valid user' do
    get user_mailing_lists_path(@user)
    assert_response :success
  end

  test 'should get show when logged in as valid user' do
    get user_mailing_list_path(@user, @mailing_list_one)
    assert_response :success
  end

  test 'should get edit when logged in as valid user' do
    get edit_user_mailing_list_path(@user, @mailing_list_one), headers: { 'Referer': root_url }
    assert_response :success
  end

  test 'should post create when logged in as valid user and commit_value is "confirm"' do
    post user_mailing_lists_path(@user), params: {
                                                   mailing_list: {
                                                     from_name: 'test_user',
                                                     title: 'test_title',
                                                     to_graduated: true,
                                                     to_enrolled: true,
                                                     content: 'test_content',
                                                     user_id: @user.id,
                                                   },
                                                   commit_value: 'confirm',
                                                 }
    assert_response :redirect
  end

  test 'should post create when logged in as valid user and commit_value is "template"' do
    post user_mailing_lists_path(@user), params: {
                                                   mailing_list: {
                                                     from_name: 'test_user',
                                                     title: 'test_title',
                                                     to_graduated: true,
                                                     to_enrolled: true,
                                                     content: 'test_content',
                                                     user_id: @user.id,
                                                   },
                                                   commit_value: 'template',
                                                 }
    assert_equal '作成中のメールをテンプレートとして保存しました<br>' \
                 '次回以降いつでも呼び出して使用できます', flash[:info]
    assert_redirected_to new_user_mailing_list_path(@user)
  end
end
