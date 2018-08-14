class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.float :hours_pledged
      t.string :phone_number
      t.string :zipcode
      t.string :twitter_handle
      t.boolean :enable_text_checkins
      t.boolean :enable_start_conversations
      t.string :resume_link

      t.timestamps null: false
    end
  end
end
