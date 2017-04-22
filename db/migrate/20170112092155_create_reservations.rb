class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.integer :timetable_id                 # タイムテーブルのid
      t.string :band_name                     # 予約バンド名
      t.integer :resavation_date              # 予約日
      t.string :resavation_koma               # 予約コマ（何コマ目か）
      t.references :user, foreign_key: true
      
      t.timestamps
    end
    add_index :reservations, :resavation_date
    add_index :reservations, :resavation_koma
  end
end
