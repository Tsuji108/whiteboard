class User < ApplicationRecord
    
    # 記憶トークンと有効化トークン用のクラス変数
    attr_accessor :remember_token, :activation_token
    
    # ページネーションでの１ページの表示数
    paginates_per  20
    
    # DB保存前にメールアドレスを小文字に
    before_save   :downcase_email
    
    # ユーザ作成前に有効化トークンとダイジェストを作成
    before_create :create_activation_digest
    
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
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      # update_columns(activated: ture, activated_at: Time.zone.now)
    end
  
    # 有効化用のメールを送信する
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
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
    
end
