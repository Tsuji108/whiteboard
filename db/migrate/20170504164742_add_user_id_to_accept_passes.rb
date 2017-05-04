class AddUserIdToAcceptPasses < ActiveRecord::Migration[5.0]
  def change
    add_column :accept_passes, :user_id, :integer
  end
end
