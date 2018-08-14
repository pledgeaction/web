class ChangeTypeToKind < ActiveRecord::Migration[4.2]
  def change
    rename_column :peers, :type, :kind
    rename_column :follows, :type, :kind
  end
end
