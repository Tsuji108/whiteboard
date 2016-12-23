class CreateTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :timetables do |t|
      t.date :from_date
      t.date :to_date
      t.integer :max_koma
      t.text :times

      t.timestamps
    end
  end
end
