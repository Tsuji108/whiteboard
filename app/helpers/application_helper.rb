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
  
  # 長文を先頭から決められた文字数表示する
  def my_truncate(str, len)
    truncate(str, length: len, omission: " ...")
  end
end
