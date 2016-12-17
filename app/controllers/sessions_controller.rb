# frozen_string_literal: true
class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user # 一時セッションにユーザIDを保存
        remember(user)
        redirect_back_or user
      else
        message = "アカウントが有効化されていません<br>
                      #{view_context.link_to "アカウント有効化メールを再送信", resend_user_path(user)}"
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
