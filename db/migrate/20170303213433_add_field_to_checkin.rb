class AddFieldToCheckin < ActiveRecord::Migration
  def change
    add_column :checkins, :last_question, :string
  end
end
