class AddUserPartyId < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :party_identification, :string
  end
end
