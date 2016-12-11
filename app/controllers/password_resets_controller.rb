class PasswordResetsController < ApplicationController
  
  # hidden_field_tagからメールアドレスを取得しユーザを設定
  before_action :get_user,   only: [:edit, :update]
  
  # 正しいユーザーかどうか確認
  before_action :valid_user, only: [:edit, :update]
  
  # 期限切れかどうかを確認する
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定のためのメールを送信しました"
      redirect_to root_url
    else
      flash.now[:danger] = "指定のメールアドレスが見つかりません"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "パスワードは空白にできません")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "パスワードを再設定しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    # ストロングパラメータ
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # hidden_field_tagからメールアドレスを取得
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # 期限切れかどうかを確認
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効時間切れです"
        redirect_to new_password_reset_url
      end
    end
    
end