class AddIndexToTracks < ActiveRecord::Migration
  def change
    add_index :tracks, :version
  end
end
