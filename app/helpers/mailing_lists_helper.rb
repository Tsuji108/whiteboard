module MailingListsHelper
  # メール作成時の複数行の改行表示に対応
  def apply_multiple_br(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, "<br>")
  end
end
