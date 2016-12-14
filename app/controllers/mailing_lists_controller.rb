class MailingListsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :confirm]
  before_action :correct_user,   only: [:new, :create, :confirm]
  
  def new
    @mailing_list = current_user.mailing_lists.build()
  end
  
  def create
    @mailing_list = current_user.mailing_lists.build(mailing_list_params)
    @mailing_list.save
    redirect_to confirm_user_mailing_list_path(current_user, @mailing_list)
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
  
  private

  # ストロングパラメータの設定
  def mailing_list_params
    params.require(:mailing_list).permit(:name, :title, :non_graduated, :graduated, :content)
  end
end
