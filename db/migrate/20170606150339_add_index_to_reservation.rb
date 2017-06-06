class AddIndexToReservation < ActiveRecord::Migration[5.0]
  def change
    add_index :reservations, :timetable_id
  end
end
