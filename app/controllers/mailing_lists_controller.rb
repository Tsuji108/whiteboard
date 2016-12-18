class MailingListsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :prohibit_direct_access, only: [:edit, :confirm, :send_ml]
  
  def index
    @mailing_lists = MailingList.order(:updated_at).reverse_order.page(params[:page])
  end
  
  def show
    @mailing_list = MailingList.find(params[:id])
    pagenate_par = 20   # indexでの１ページの表示数
    ml_show_number = MailingList.where("updated_at >= ?", @mailing_list.updated_at).count # 該当のshowがindex内で何番目に表示されるかを取得
    if ml_show_number % pagenate_par == 0
      @previous_page = ml_show_number / pagenate_par      # 該当のshowは何ページ目に属しているかを保存
    else
      @previous_page = ml_show_number / pagenate_par + 1
    end
  end
  
  def new
    @mailing_list = current_user.mailing_lists.build()
    @mailing_list.from_name = current_user.name
    @mailing_list.title = "#{current_user.name}さんからのメール"
  end
  
  def create
    @mailing_list = current_user.mailing_lists.build(mailing_list_params)
    if @mailing_list.save
      old_mails = MailingList.where("created_at < ?", 3.month.ago)  # 3ヶ月以上前のメールを選択
      old_mails.destroy unless old_mails.count == 0                 # 3ヶ月以上前のメールが存在する場合は削除
      redirect_to confirm_user_mailing_list_path(current_user, @mailing_list)
    else
      render 'new'
    end
  end
  
  def edit
    @mailing_list = MailingList.find(params[:id])
  end
  
  def update
    @mailing_list = MailingList.find(params[:id])
    if @mailing_list.update_attributes(mailing_list_params)
      redirect_to confirm_user_mailing_list_path(current_user, @mailing_list)
    else
      render 'edit'
    end
  end

  def confirm
    @mailing_list = MailingList.find(params[:id])
  end
  
  def send_ml
    @mailing_list = MailingList.find(params[:id])
    unless @mailing_list.send_circle_mail
      flash[:danger] = "サークルメールを送信できませんでした"
    else
      flash[:info] = "サークルメールを送信しました"
    end
      redirect_to root_path
  end
  
  private

  # ストロングパラメータの設定
  def mailing_list_params
    params.require(:mailing_list).permit(:from_name, :title, :to_enrolled, :to_graduated, :content)
  end
end
