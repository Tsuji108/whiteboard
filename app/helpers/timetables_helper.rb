module TimetablesHelper
  # ユーザーがタイムテーブルを保存していればtrue、その他ならfalseを返す
  def user_saved_timetable?
    current_user.timetables.exists?(saved: true)
  end
end
