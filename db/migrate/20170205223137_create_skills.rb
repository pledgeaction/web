class CreateSkills < ActiveRecord::Migration[4.2]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
