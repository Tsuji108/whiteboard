class User < ApplicationRecord
    
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
    validates :password, presence: true, length: { minimum: 6 }
    
end
