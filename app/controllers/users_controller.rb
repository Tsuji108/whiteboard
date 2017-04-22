# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :non_activated_user,  only: :resend
  before_action :prohibit_direct_access, only: :resend
  before_action :set_user,   only: [:show, :edit, :update, :destroy, :resend]

  def index
    @users = User.where(activated: true).order(:created_at).reverse_order.page(params[:page])
  end

  def show
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
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'プロフィールを更新しました'
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'メンバーから削除しました'
    redirect_to users_url
  end

  # アカウント有効化メールを再送信
  def resend
    if @user.save
      @user.send_activation_email
      flash[:info] = 'アカウント有効化のためのメールを再送信しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "アカウント有効化のためのメールを送信できませんでした<br>
                        しばらく待ってから再度実行してください"
      redirect_to root_url
    end
  end

  private

    # ストロングパラメータの設定
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # アカウント有効化メールを送信可能なユーザかどうか確認
    def non_activated_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user && !@user.activated?
    end
end
