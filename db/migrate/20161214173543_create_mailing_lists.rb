class CreateMailingLists < ActiveRecord::Migration[5.0]
  def change
    create_table :mailing_lists do |t|
      t.string :from_name
      t.string :title
      t.boolean :to_enrolled, default: true
      t.boolean :to_graduated, default: false
      t.text :content
      t.boolean :saved, default: false
      t.boolean :sent, default: false
      t.datetime :sent_at

      t.timestamps
    end
  end
end
