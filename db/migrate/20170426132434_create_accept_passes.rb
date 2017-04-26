class CreateAcceptPasses < ActiveRecord::Migration[5.0]
  def change
    create_table :accept_passes do |t|
      t.string  :accept_pass

      t.timestamps
    end
  end
end
