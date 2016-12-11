class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "[WhiteBoard] アカウント有効化"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "[WhiteBoard] パスワード再設定"
  end
  
end