class AddSavedAndSentAtToMailingLists < ActiveRecord::Migration[5.0]
  def change
    add_column :mailing_lists, :saved, :boolean, default: false
    add_column :mailing_lists, :sent_at, :datetime
  end
end
