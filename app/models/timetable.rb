class Timetable < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # バリデーション
  #validates :times,  presence: true, length: { maximum: 1000 }
end
