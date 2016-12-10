class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user     # 一時セッションにユーザIDを保存
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)   # クッキーにユーザIDと記憶トークンを保存（「入力項目を保存」にチェックが有る場合）
      redirect_to user
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