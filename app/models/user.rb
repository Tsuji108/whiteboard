# frozen_string_literal: true
class User < ApplicationRecord
  has_many :mailing_lists
  has_many :timetables
  has_many :reservations
  
  # 記憶トークン・有効化トークン・パスワード再設定トークン用のクラス変数
  attr_accessor :remember_token, :activation_token, :reset_token

  # ページネーションでの１ページの表示数
  paginates_per 20

  # DB保存前にメールアドレスを小文字に
  before_save :downcase_email

  # ユーザ作成前に有効化トークンとダイジェストを作成
  before_save :create_activation_digest

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # メールアドレスの正規表現
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    unless: proc {|a| a.email.blank? } # メールアドレスが入力されている場合のみ確認
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # プロフ更新時のみnilを許可(パスはそのまま)
  validates :birth_place, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :department, length: { maximum: 255 }
  validates :part, length: { maximum: 255 }
  validates :genre, length: { maximum: 5000 }
  validates :profile, length: { maximum: 5000 }

  # 渡された文字列のハッシュ値を返す(フィクスチャ用)
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す（rememberメソッドで使用）
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのために記憶トークンをハッシュ化してDBに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがユーザのダイジェストと一致したらtrueを返す
  # (記憶トークン・有効かトークンで兼用)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報（記憶ダイジェスト）をDBから破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
  # アカウント有効化していないユーザを削除(config/schedule.rbで設定)
  def delete_non_activated_users
    inactivated_users = User.where(activated: false).where("created_at < ?", 1.hour.ago) # 1時間以上有効化されていないユーザを選択
    inactivated_users.destroy unless inactivated_users.count == 0
  end
end
