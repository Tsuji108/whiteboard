class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.text :message  # お知らせ内容

      t.timestamps
    end
  end
end
