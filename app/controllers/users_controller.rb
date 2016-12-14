# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :non_activated_correct_user,  only: :resend

  def index
    @users = User.where(activated: true).order(:created_at).reverse_order.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'アカウント有効化のためのメールを送信しました'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'プロフィールを更新しました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'メンバーから削除しました'
    redirect_to users_url
  end

  # アカウント有効化メールを再送信
  def resend
    @user = User.find(params[:id])
    if @user.save
      @user.send_activation_email
      flash[:info] = 'アカウント有効化のためのメールを再送信しました'
    else
      flash[:danger] = "アカウント有効化のためのメールを送信できませんでした<br>
                        しばらく待ってから再度実行してください"
    end
    redirect_to :back
  end

  private

  # ストロングパラメータの設定
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
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
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  # アカウント有効化メールを送信可能なユーザかどうか確認
  def non_activated_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user && !@user.activated?
  end
end
