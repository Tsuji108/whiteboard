class RemoveEmailToMailingLists < ActiveRecord::Migration[5.0]
  def change
    remove_column :mailing_lists, :email, :string
  end
end
