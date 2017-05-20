# frozen_string_literal: true
module UsersHelper
  # TODO: リリース時は消すかも
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]

    if user.prof_img?
      image_tag user.prof_img.url 
    else
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: 'gravatar')
    end
  end
  
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location # アクセスしようとしたURLを記憶
      flash[:danger] = 'ログインしてください'
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    unless params[:user_id].nil?          # params[:user_id]が存在するときは
      @user = User.find(params[:user_id]) # params[:user_id]をユーザIDとしてユーザを設定
    else                                  # params[:user_id]が存在しないときは
      @user = User.find(params[:id])      # params[:id]をユーザIDとしてユーザを設定
    end
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
