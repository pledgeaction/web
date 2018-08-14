class AddFieldToCheckin < ActiveRecord::Migration[4.2]
  def change
    add_column :checkins, :last_question, :string
  end
end
