class RemoveTracksIndex < ActiveRecord::Migration
  def up
    remove_index :tracks, [:external_id, :version]
    add_index :tracks, :id, unique: true
  end
end
