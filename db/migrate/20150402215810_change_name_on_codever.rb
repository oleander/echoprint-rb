class ChangeNameOnCodever < ActiveRecord::Migration
  def change
    rename_column :tracks, :codever, :version
  end
end
