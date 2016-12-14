class MailingList < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # nameのバリデーション
  validates :name,  presence: true, length: { maximum: 50 }
  
  # titleのバリデーション
  validates :title,  presence: true, length: { maximum: 255 }
  
  # contentのバリデーション
  validates :content,  presence: true, length: { maximum: 5000 }
end
