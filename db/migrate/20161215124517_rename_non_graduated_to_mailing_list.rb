class RenameNonGraduatedToMailingList < ActiveRecord::Migration[5.0]
  def change
    rename_column :mailing_lists, :non_graduated, :enrolled
  end
end
