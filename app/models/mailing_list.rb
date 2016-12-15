class MailingList < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # nameのバリデーション
  validates :name,  presence: true, length: { maximum: 50 }
  
  # titleのバリデーション
  validates :title,  presence: true, length: { maximum: 255 }
  
  # メール送信先のバリデーション
  validates :graduated, acceptance: true, unless: proc {|a| a.enrolled? }
  
  # contentのバリデーション
  validates :content,  presence: true, length: { maximum: 5000 }
end
