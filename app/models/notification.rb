class Notification < ApplicationRecord

  # ページネーションでの１ページの表示数
  paginates_per 20
  
  validates :message, presence: true, length: { maximum: 5000 }
end
