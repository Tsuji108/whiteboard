class RenameColumnToMailingList < ActiveRecord::Migration[5.0]
  def change
    rename_column :mailing_lists, :sendto_non_graduated, :non_graduated
    rename_column :mailing_lists, :sendto_graduated, :graduated
  end
end
