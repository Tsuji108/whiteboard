# frozen_string_literal: true
module ApplicationHelper
  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = 'KIT WhiteBoard'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
  
  # メール作成時の複数行の改行表示に対応
  def br(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, "<br>")
  end
end
