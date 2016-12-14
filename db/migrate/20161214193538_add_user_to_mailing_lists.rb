class AddUserToMailingLists < ActiveRecord::Migration[5.0]
  def change
    add_reference :mailing_lists, :user, foreign_key: true
  end
end
