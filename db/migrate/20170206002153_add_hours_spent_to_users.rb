class AddHoursSpentToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :hours_spent_last_week, :integer
  end
end
