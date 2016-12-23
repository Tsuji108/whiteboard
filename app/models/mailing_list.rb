class MailingList < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # ページネーションでの１ページの表示数
  paginates_per 20
  
  # from_nameのバリデーション
  validates :from_name,  presence: true, length: { maximum: 50 }
  
  # titleのバリデーション
  validates :title,  presence: true, length: { maximum: 255 }
  
  # メール送信先のバリデーション
  validates :to_graduated, acceptance: true, unless: proc {|a| a.to_enrolled? }
  
  # contentのバリデーション
  validates :content,  presence: true, length: { maximum: 5000 }
  
  # サークルメールを送信(成功でtrue、失敗でfalseを返す)
  def send_circle_mail
    if self.to_enrolled && self.to_graduated  # 在校生・卒業生に送信する場合
      users = User.where(activated: true)
    elsif self.to_enrolled                    # 在校生のみに送信する場合
      users = User.where(activated: true).where(graduated: false)
    elsif self.to_graduated                   # 卒業生のみに送信する場合
      users = User.where(activated: true).where(graduated: true)
    else                                       # 送信できない場合
      return false
    end
    users.each do |user|  # user一人ずつに送信(本番環境では50人以上同時送信できないため)
      UserMailer.circle_mail(self, user).deliver_later
    end
    return true
  end
  
  # 3年以上前のメールを過去のメール一覧から削除(config/schedule.rbで設定)
  def delete_old_mails
    old_mails = MailingList.where(sent: true).where("sent_at < ?", 3.years.ago)
    old_mails.destroy unless old_mails.count == 0
  end
end