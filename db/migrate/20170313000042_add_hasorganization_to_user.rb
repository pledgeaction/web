class AddHasorganizationToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_organization, :boolean
  end
end
