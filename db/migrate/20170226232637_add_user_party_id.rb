class AddUserPartyId < ActiveRecord::Migration
  def change
    add_column :users, :party_identification, :string
  end
end
