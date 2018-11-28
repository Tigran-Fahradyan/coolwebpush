class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :notif_id
      t.string :name
      t.string :auth_key

      t.timestamps
    end
  end
end
