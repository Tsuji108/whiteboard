# frozen_string_literal: true
class SessionsController < ApplicationController
  
  def new
    # ログイン済みの時
    if logged_in?
      
      # タイムテーブルが存在する場合はタイムテーブルを表示
      unless Timetable.where(published: true).last.nil?
        redirect_to user_timetable_path(current_user, Timetable.where(published: true).last)
      
      # そうでない場合はプロフィールページを表示
      else
        redirect_to current_user
      end
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user # 一時セッションにユーザIDを保存
        remember(user)
        redirect_back_or user
      else
        message = "アカウントが有効化されていません<br>新規登録ページからアカウント有効かメールを再送信してください"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスとパスワードが一致しません'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
