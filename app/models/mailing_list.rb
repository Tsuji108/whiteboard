class MailingList < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # ページネーションでの１ページの表示数
  paginates_per 20
  
  # バリデーション
  validates :from_name,  presence: true, length: { maximum: 50 }
  validates :title,  presence: true, length: { maximum: 255 }
  validates :to_graduated, acceptance: true, unless: proc {|a| a.to_enrolled? }
  validates :content,  presence: true, length: { maximum: 5000 }
  
  # サークルメールを送信(成功でtrue、失敗でfalseを返す)
  def send_circle_mail
    if self.to_enrolled && self.to_graduated  # 在校生・卒業生に送信する場合
      users = User.where(activated: true).where(mail_receive: true)
    elsif self.to_enrolled                    # 在校生のみに送信する場合
      users = User.where(activated: true).where(graduated: false).where(mail_receive: true)
    elsif self.to_graduated                   # 卒業生のみに送信する場合
      users = User.where(activated: true).where(graduated: true).where(mail_receive: true)
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
  
  # 1時間以上送信していないメールを削除(config/schedule.rbで設定)
  def delete_non_send_mails
    non_send_mails = MailingList.where(saved: false).where(sent: false).where("updated_at < ?", 1.hour.ago)
    non_send_mails.destroy unless non_send_mails.count == 0
  end
end
