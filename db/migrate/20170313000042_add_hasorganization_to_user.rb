class AddHasorganizationToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :has_organization, :boolean
  end
end
