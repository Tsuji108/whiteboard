# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string   :name              # 名前
      t.string   :email             # メール
      t.string   :birth_place       # 出身地
      t.string   :address           # 現住所
      t.string   :sex               # 性別
      t.date     :birth_day         # 誕生日
      t.string   :blood_type        # 血液型
      t.date     :enroll_year       # 入学年
      t.string   :department        # 学科など
      t.part     :part              # パート
      t.string   :password_digest
      t.string   :remember_digest
      t.boolean  :admin,             default: false
      t.string   :activation_digest
      t.boolean  :activated,         default: false
      t.datetime :activated_at
      t.string   :reset_digest
      t.datetime :reset_sent_at
      t.boolean  :graduated,         default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
