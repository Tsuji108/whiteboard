class Timetable < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # ページネーションでの１ページの表示数
  paginates_per 20
  
  # 3年以上前のタイムテーブルを過去のタイムテーブル一覧から削除(config/schedule.rbで設定)
  def delete_old_timetables
    old_timetables = Timetable.where(published: true).where("published_at < ?", 3.years.ago)
    old_timetables.destroy unless old_timetables.count == 0
  end
  
  # 1時間以上公開していないタイムテーブルを削除(config/schedule.rbで設定)
  def delete_non_published_timetables
    non_published_timetables = Timetable.where(saved: false).where(published: false).where("updated_at < ?", 1.hour.ago)
    non_published_timetables.destroy unless non_published_timetables.count == 0
  end
end
