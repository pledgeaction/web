class AddHoursSpentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hours_spent_last_week, :integer
  end
end
