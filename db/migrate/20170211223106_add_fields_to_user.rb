class AddFieldsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :referring_user_id, :integer
    add_column :users, :url, :string
    add_column :users, :company, :string
  end
end
