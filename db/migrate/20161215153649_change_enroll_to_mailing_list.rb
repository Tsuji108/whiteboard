class ChangeEnrollToMailingList < ActiveRecord::Migration[5.0]
  def change
    change_column_default :mailing_lists, :enrolled, true
  end
end
