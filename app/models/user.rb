class User < ApplicationRecord
    
    # 記憶トークン用のクラス変数
    attr_accessor :remember_token
    
    # ページネーションの表示数
    paginates_per  15
    
    # DB保存前にメールアドレスを小文字に
    before_save { email.downcase! }
    
    # nameのバリデーション
    validates :name,  presence: true, length: { maximum: 50 }
    
    # emailのバリデーション
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  # メールアドレスの正規表現
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }   # 大文字小文字を無視して一意
    
    # passwordのバリデーション
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  # プロフ更新時のみnilを許可(パスはそのまま)
    
    
    # 渡された文字列のハッシュ値を返す(フィクスチャ用)
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # ランダムなトークンを返す（rememberメソッドで使用）
    def User.new_token
      SecureRandom.urlsafe_base64
    end
    
    # 永続セッションのために記憶トークンをハッシュ化してDBに記憶する
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end
  
    # 渡された記憶トークンがユーザーの記憶ダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  
    # ユーザーのログイン情報（記憶ダイジェスト）をDBから破棄する
    def forget
      update_attribute(:remember_digest, nil)
    end
  
end
