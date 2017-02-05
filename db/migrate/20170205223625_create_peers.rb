class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.integer :from_user_id
      t.string :to
      t.string :type

      t.timestamps null: false
    end
  end
end
