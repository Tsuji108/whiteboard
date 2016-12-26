class Timetable < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # コマ毎の"hh:mm〜hh:mm"を配列で保存
  #serialize :times
end
