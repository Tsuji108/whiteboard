# frozen_string_literal: true
class ApplicationController < ActionController::Base
  before_action :set_cache_headers

  protect_from_forgery with: :exception

  include SessionsHelper
  include UsersHelper
  include MailingListsHelper
  include TimetablesHelper
  
  # URL直打ちでのアクセスを禁止
  def prohibit_direct_access
    if request.referer.nil?
      flash[:danger] = '不正な操作です<br>トップページに移動します'
      redirect_to root_path
    end
  end
  
  # この関数を呼び出したアクション名を取得する
  def self.action_name
    return *(caller[1].scan(/`(.+)'/)[0])
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  private

    # キャッシュを削除
    def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
