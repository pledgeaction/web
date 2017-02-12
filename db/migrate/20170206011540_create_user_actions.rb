class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.integer :action_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
