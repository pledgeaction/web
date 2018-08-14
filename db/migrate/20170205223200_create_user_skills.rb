class CreateUserSkills < ActiveRecord::Migration[4.2]
  def change
    create_table :user_skills do |t|
      t.integer :skill_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
