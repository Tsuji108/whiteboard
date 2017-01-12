class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.string :band_name                     # 予約バンド名
      t.date :resavation_date                 # 予約日
      t.integer :resavation_koma              # 予約コマ（何コマ目か）
      t.references :user, foreign_key: true
      t.references :timetable, foreign_key: true
      
      t.timestamps
    end
  end
end
