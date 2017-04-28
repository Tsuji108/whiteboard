# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :add_admin]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :add_admin]
  before_action :non_activated_user,  only: :resend
  before_action :prohibit_direct_access, only: :resend
  before_action :set_user,   only: [:show, :edit, :update, :destroy, :resend, :add_admin]

  def index
    @q = User.search(params[:q])
    @users = @q.result(distinct: true).where(activated: true).order(:created_at).reverse_order.page(params[:page])
  end

  def show
    # 削除されたユーザの場合はルートにリダイレクト
    redirect_to root_url if deleted_user?(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:accept_pass] == ENV['ACCEPT_PASS']
      if @user.save
        @user.send_activation_email
        flash[:info] = 'アカウント有効化のためのメールを送信しました<br>
                        再送信したい場合は、登録したアドレスとパスワードでログインしてください'
        redirect_to root_path
      else
        flash.now[:danger] = '新規登録に失敗しました'
        render :new
      end
    else
      flash.now[:danger] = '承認パスワードが一致しません'
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
    @user.update_attributes(name: '削除されたユーザ', email: 'deleteduser.'+SecureRandom.hex(110)+'@example.com',
                            birth_place: nil, address: nil, sex:nil, birth_day: nil,
                            enroll_year: nil, department: nil, part: nil, genre: nil, profile: nil, admin: false,
                            mail_receive: false)
    if params[:page] == 'index' # ユーザー一覧画面から削除された場合
      flash[:success] = 'メンバーから削除しました'
      redirect_to users_url
    else                        # プロフィール編集画面から削除された場合
      flash[:success] = 'アカウントを削除しました'
      log_out if logged_in?
      redirect_to root_path
    end
  end

  # アカウント有効化メールを再送信
  def resend
    @user.send_activation_email
    flash[:info] = 'アカウント有効化のためのメールを再送信しました'
    redirect_to root_url
  end

  def add_admin
    if @user.update_attribute(:admin, true)
      flash[:success] = 'ユーザーに管理者権限を与えました'
    else
      flash[:success] = 'だめでした'
    end
    redirect_to users_url
  end

  private

    # ストロングパラメータの設定
    def user_params
      params.require(:user).permit(:name, :email, :birth_place, :address, :sex,
                                   :birth_day, :enroll_year, :department, :graduated,
                                   :part, :genre, :profile, :mail_receive, :password, :password_confirmation)
    end

    def set_user
      if User.exists?(params[:id])
        @user = User.find(params[:id])
      else
        redirect_to root_path
      end
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
