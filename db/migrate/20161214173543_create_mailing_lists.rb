class CreateMailingLists < ActiveRecord::Migration[5.0]
  def change
    create_table :mailing_lists do |t|
      t.string :from_name
      t.string :title
      t.boolean :enrolled, default: true
      t.boolean :graduated, default: false
      t.text :content

      t.timestamps
    end
  end
end
