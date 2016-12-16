class RenameColumnsToMailingLists < ActiveRecord::Migration[5.0]
  def change
    rename_column :mailing_lists, :enrolled, :to_enrolled
    rename_column :mailing_lists, :graduated, :to_graduated
  end
end
