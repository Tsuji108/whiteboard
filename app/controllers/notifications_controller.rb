class NotificationsController < ApplicationController
  before_action :logged_in_user,   only: [:index,:new, :create, :edit, :update, :destroy]
  before_action :sudo_user,        only: [:new, :create, :edit, :update, :destroy]
  before_action :set_notification, only: [:edit, :update, :destroy]

  def index
    @notifications = Notification.order(:created_at).reverse_order.page(params[:page])
    current_user.update_attribute(:checked_notification, true)  # お知らせページ表示でchecked_notificationをtrueに
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      users = User.where(activated: true)                     # アクティブなユーザーを取得
      users.each do |user|
        user.update_attribute(:checked_notification, false)   # 全ユーザーのchecked_notificationをfalseに
      end
      flash[:info] = 'お知らせを登録しました'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @notification.update_attributes(notification_params)
      flash[:success] = 'お知らせを編集しました'
      redirect_to notifications_path
    else
      render :new
    end
  end

  def destroy
    @notification.destroy
    redirect_to notifications_path
  end

  def creator
  end

  private

    # ストロングパラメータの設定
    def notification_params
      params.require(:notification).permit(:message)
    end

    def set_notification
      if Notification.exists?(params[:id])
        @notification = Notification.find(params[:id])
      else
        redirect_to root_path
      end
    end

    # イトウかソネダのみ編集可能
    def sudo_user
      if current_user.id != 1 && current_user.id != 2
        redirect_to root_path
      end
    end
end
