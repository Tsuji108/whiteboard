module MailingListsHelper
  # メール作成時の複数行の改行表示に対応
<<<<<<< HEAD
  def apply_multiple_br(target)
=======
  def br(target)
>>>>>>> 4446601... Add add_template_helper to UserMailer
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, "<br>")
  end
end
