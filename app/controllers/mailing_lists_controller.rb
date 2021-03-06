class MailingListsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :prohibit_direct_access, only: [:edit, :applay_saved_ml, :destroy_saved_ml, :confirm, :send_ml]
  before_action :set_mailing_list, only: [:show, :edit, :update, :destroy_saved_ml, :confirm, :send_ml]
  before_action :set_saved_mailing_lists, only: [:new, :create, :edit, :update, :applay_saved_ml, :destroy_saved_ml]
  
  def index
    @q = MailingList.search(params[:q])
    @mailing_lists = @q.result(distinct: true).where(sent: true).order(sent_at: :desc).page(params[:page])
  end
  
  def show
  end
  
  def new
    @mailing_list = current_user.mailing_lists.build()
    @mailing_list.from_name = current_user.name
  end
  
  def create
    @mailing_list = current_user.mailing_lists.build(mailing_list_params)
    if @mailing_list.save
      mail_confirm_and_template_process
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @mailing_list.update_attributes(mailing_list_params)
      mail_confirm_and_template_process
    else
      render :edit
    end
  end
  
  def applay_saved_ml
    @mailing_list = MailingList.find(params[:id]).dup # PATCHリクエストを送信しないようにdupでオブジェクトをコピーして新たに作成
    flash.now[:info] = "選択したテンプレートを適用しました"
    render :new
  end
  
  def destroy_saved_ml
    @mailing_list.destroy
    flash[:danger] = "選択したテンプレートを削除しました"
    redirect_to new_user_mailing_list_path(current_user)
  end

  def confirm
  end
  
  def send_ml
    @mailing_list.update_attribute(:title, "無題") if @mailing_list.title.blank?
    if @mailing_list.send_circle_mail
      @mailing_list.update_columns(sent: true, sent_at: Time.zone.now)
      flash[:info] = "サークルメールを送信しました"
    else
      flash[:danger] = "サークルメールを送信できませんでした"
    end
      redirect_to root_path
  end
  
  private

    # ストロングパラメータの設定
    def mailing_list_params
      params.require(:mailing_list).permit(:from_name, :title, :to_enrolled, :to_graduated, :content)
    end
    
    def set_mailing_list
      if MailingList.exists?(params[:id])
        @mailing_list = MailingList.find(params[:id])
      else
        redirect_to root_path
      end
    end
    
    # カレントユーザが保存中のメールを取得
    def set_saved_mailing_lists
      @saved_mailing_lists = current_user.mailing_lists.where(saved: true).order(created_at: :desc) if user_saved_mail?
    end
    
    # メールの送信前確認とテンプレート保存の処理（newとeditで同じ処理のためまとめる）
    def mail_confirm_and_template_process
      if params[:commit_value] == "confirm"                           # 「確認」が実行された場合
        redirect_to confirm_user_mailing_list_path(current_user, @mailing_list)
      elsif params[:commit_value] == "template"                       # 「現在の内容を保存」が実行された場合
        if current_user.mailing_lists.where(saved: true).count < 5    # メール保存数が５件より少なければ
          @mailing_list.update_attribute(:title, "無題") if @mailing_list.title.blank?
          @mailing_list.update_attribute(:saved, true)
          flash[:info] = "作成中のメールをテンプレートとして保存しました<br>
                          次回以降いつでも呼び出して使用できます"
        else
          flash[:danger] = "保存可能なメールは5件までです"
        end
        redirect_to new_user_mailing_list_path(current_user)
      else          
        flash[:danger] = "不正な操作です"
        redirect_to root_path
      end
    end
end
