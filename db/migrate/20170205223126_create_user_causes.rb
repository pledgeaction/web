class CreateUserCauses < ActiveRecord::Migration
  def change
    create_table :user_causes do |t|
      t.integer :cause_id
      t.integer :user_id
      t.boolean :primary

      t.timestamps null: false
    end
  end
end
