class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :checked_notification, :boolean, default: false, null: false
  end
end
