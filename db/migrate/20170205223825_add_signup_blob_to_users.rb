class AddSignupBlobToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signup_blob, :hstore
  end
end
