# frozen_string_literal: true
class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id]) # params[:id]ではactivation_tokenが参照される
      user.activate
      log_in user
      flash[:success] = '九工大軽音楽部へようこそ！'
      redirect_to user
    else
      flash[:danger] = 'アカウントの有効化に失敗しました'
      redirect_to root_url
    end
  end

  def resend
  end

  def create
    @user = User.find_by(email: params[:resend][:email])
    if @user && !@user.activated?
      @user.send_activation_email
      flash[:info] = 'アカウント有効化のためのメールを再送信しました'
      redirect_to root_url
    else
      flash.now[:danger] = "アカウント有効化のためのメールを送信できませんでした<br>
                            指定の情報は登録されていないか、すでに有効化されている可能性があります"
      render :resend
    end
  end
end
