# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string   :name              # 名前
      t.string   :email             # メールアドレス
      t.string   :birth_place       # 出身地
      t.string   :address           # 現住所
      t.string   :sex, default: '男' # 性別
      t.date     :birth_day         # 誕生日
      t.date     :enroll_year       # 入学年
      t.string   :department        # 学科など
      t.string   :part              # 担当パート
      t.text     :genre             # 好きなジャンルやバンドなど
      t.text     :profile           # 自己紹介
      t.string   :password_digest
      t.string   :remember_digest
      t.boolean  :admin,             default: false
      t.string   :activation_digest
      t.boolean  :activated,         default: false
      t.datetime :activated_at
      t.string   :reset_digest
      t.datetime :reset_sent_at
      t.boolean  :graduated,         default: false
      t.boolean  :mail_receive,      default: true  # メールを受け取るかどうか

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
