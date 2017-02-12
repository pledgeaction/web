class ChangeTypeToKind < ActiveRecord::Migration
  def change
    rename_column :peers, :type, :kind
    rename_column :follows, :type, :kind
  end
end
