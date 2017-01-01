# frozen_string_literal: true
require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user            = users(:ito)
    @other_user      = users(:soneda)
    @non_active_user = users(:non_active_user)
  end

  test 'should get new' do
    get login_path
    assert_response :success
  end

  test 'should redirect new when logged in as valid user' do
    log_in_as(@user)
    get login_path
    assert_redirected_to user_path(@user)
  end

  test 'should create when authenticationed as valid user' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_not_nil cookies['user_id']
    assert_not_nil cookies['remember_token']
    assert_redirected_to user_path(@user)
  end

  test 'should not create when authenticationed as non active user' do
    post login_path, params: { session: { email: @non_active_user.email,
                                          password: 'password' } }
    message = 'アカウントが有効化されていません<br>' \
              "#{ApplicationController.new.view_context.link_to "アカウント有効化メールを再送信", resend_user_path(@non_active_user)}"
    assert_equal message, flash[:warning]
    assert_redirected_to root_url
  end

  test 'should not create when authenticationed as not exist email' do
    post login_path, params: { session: { email: 'not_exist@example.com',
                                          password: 'password' } }
    assert_equal 'メールアドレスとパスワードが一致しません', flash[:danger]
    assert_response :success
  end

  test 'should not create when authenticationed as invalid password' do
    post login_path, params: { session: { email: @non_active_user.email,
                                          password: 'invalid' } }
    assert_equal 'メールアドレスとパスワードが一致しません', flash[:danger]
    assert_response :success
  end

  test 'should destroy when logged in as valid user' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    delete logout_path
    assert_nil session['user_id']
    assert_empty cookies['user_id']
    assert_empty cookies['remember_token']
    assert_redirected_to root_url
  end
end
