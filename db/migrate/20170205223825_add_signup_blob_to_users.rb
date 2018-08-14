class AddSignupBlobToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :signup_blob, :hstore
  end
end
