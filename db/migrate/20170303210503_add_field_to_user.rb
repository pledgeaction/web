class AddFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_working_group, :boolean
  end
end
