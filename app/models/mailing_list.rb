class MailingList < ApplicationRecord
  # Userモデルとの関連付け
  belongs_to :user
  
  # from_nameのバリデーション
  validates :from_name,  presence: true, length: { maximum: 50 }
  
  # titleのバリデーション
  validates :title,  presence: true, length: { maximum: 255 }
  
  # メール送信先のバリデーション
  validates :graduated, acceptance: true, unless: proc {|a| a.enrolled? }
  
  # contentのバリデーション
  validates :content,  presence: true, length: { maximum: 5000 }
  
  # サークルメールを送信
  def send_circle_mail
    if self.enrolled && self.graduated  # 在校生・卒業生に送信する場合
      users = User.where(activated: true)
    elsif self.enrolled                 # 在校生のみに送信する場合
      users = User.where(activated: true).where(graduated: false)
    elsif                               # 卒業生のみに送信する場合
      users = User.where(activated: true).where(graduated: true)
    else                                # 送信できない場合
      return false
    end
    users.each do |user|                # user一人ずつに送信(本番環境では50人以上同時送信できないため)
      UserMailer.circle_mail(self, user).deliver_later
    end
  end
end
