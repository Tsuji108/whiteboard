class CreateTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :timetables do |t|
      t.date :from_date
      t.date :to_date
      t.text :times
      t.boolean :saved, default: false      # テンプレートとして保存されているか
      t.boolean :published, default: false  # 管理者により公開されているか
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
