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
end
