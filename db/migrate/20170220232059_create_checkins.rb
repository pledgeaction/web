class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.string :phone_number
      t.integer :hours

      t.timestamps null: false
    end

    add_index :checkins, :phone_number
  end
end
