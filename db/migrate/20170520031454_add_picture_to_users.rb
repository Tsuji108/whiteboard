class AddPictureToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :prof_img, :string
  end
end
