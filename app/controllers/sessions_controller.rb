class SessionsController < ApplicationController
  
  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user     # 一時セッションにユーザIDを保存
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)   # クッキーにユーザIDと記憶トークンを保存（「入力項目を保存」にチェックが有る場合）
        redirect_back_or user
      else
        message  = "アカウントが有効化されていません"
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
