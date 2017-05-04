class AcceptPassesController < ApplicationController
  before_action :set_accept_pass, only: [:show, :edit, :update]
  before_action :admin_user,      only: [:show, :edit, :update]
  
  def show
  end
  
  def edit
  end

  def update
    if @accept_pass.update_attributes(accept_pass_params)
      @accept_pass.update_attribute(:user_id, current_user.id)
      flash[:success] = '承認パスワードを変更しました'
      redirect_to @accept_pass
    else
      render :edit
    end
  end

  private

    # ストロングパラメータの設定
    def accept_pass_params
      params.require(:accept_pass).permit(:accept_pass)
    end

    def set_accept_pass
      if AcceptPass.exists?(params[:id])
        @accept_pass = AcceptPass.find(params[:id])
      else
        redirect_to root_path
      end
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
