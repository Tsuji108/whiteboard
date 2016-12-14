class CreateMailingLists < ActiveRecord::Migration[5.0]
  def change
    create_table :mailing_lists do |t|
      t.string :name
      t.string :title
      t.string :email
      t.boolean :non_graduated
      t.boolean :graduated
      t.text :content

      t.timestamps
    end
  end
end
