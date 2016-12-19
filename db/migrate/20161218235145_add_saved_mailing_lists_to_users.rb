class AddSavedMailingListsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :saved_mailing_lists, :string, default: ""
  end
end
