# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include MailingListsHelper
  include TimetablesHelper
  
  # URL直打ちでのアクセスを禁止
  def prohibit_direct_access
    redirect_to root_path if request.referer.nil?
  end
end
