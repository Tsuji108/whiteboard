class CreateTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :timetables do |t|
      t.date :from_date                     # タイムテーブルの開始日
      t.date :to_date                       # タイムターブルの終了日
      t.text :times                         # 各コマの時間
      t.boolean :saved, default: false      # テンプレートとして保存されているか
      t.boolean :published, default: false  # 管理者により公開されているか
      t.datetime :published_at              # 管理者により公開された日時
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
