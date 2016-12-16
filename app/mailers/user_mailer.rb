# frozen_string_literal: true
class UserMailer < ApplicationMailer
  # メーラーのviewでMailingListsHelperを使用
  add_template_helper(MailingListsHelper)
  
  # アカウント有効化
  def account_activation(user)
    @user = user
    mail to: user.email, subject: '[WhiteBoard] アカウント有効化'
  end
  
  # パスワード再設定
  def password_reset(user)
    @user = user
    mail to: user.email, subject: '[WhiteBoard] パスワード再設定'
  end
  
  # サークルメール
  def circle_mail(mailing_list, user)
    @mailing_list = mailing_list
    mail to: user.email, subject: "[WhiteBoard] #{mailing_list.title} from:#{mailing_list.from_name}"
  end
end
