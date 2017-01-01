# frozen_string_literal: true
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user            = users(:ito)
    @other_user      = users(:soneda)
    @non_active_user = users(:non_active_user)
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should get index when logged in as valid user' do
    log_in_as(@user)
    get users_path
    assert_response :success
  end

  test 'should get show when logged in as valid user' do
    log_in_as(@user)
    get user_path(@user)
    assert_response :success
  end

  test 'should get edit when logged in as valid user' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_response :success
  end

  test 'should patch update when logged in as valid user' do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_equal 'プロフィールを更新しました', flash[:success]
    assert_redirected_to user_path(@user)
  end

  test 'should destroy when logged in as admin user' do
    log_in_as(@user)
    delete user_path(@other_user)
    assert_redirected_to users_path
  end

  test 'should resend when logged in as valid user' do
    get resend_user_path(@non_active_user), headers: { 'Referer': root_url }
    assert_equal 'アカウント有効化のためのメールを再送信しました', flash[:info]
    assert_redirected_to root_url
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect destroy when logged in as not admin user' do
    log_in_as(@other_user)
    delete user_path(@user)
    assert_redirected_to root_url
  end
end
