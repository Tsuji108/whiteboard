class RenameUserToMailingList < ActiveRecord::Migration[5.0]
  def change
    rename_column :mailing_lists, :name, :from_name
  end
end
