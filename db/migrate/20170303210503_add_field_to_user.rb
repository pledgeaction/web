class AddFieldToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :has_working_group, :boolean
  end
end
