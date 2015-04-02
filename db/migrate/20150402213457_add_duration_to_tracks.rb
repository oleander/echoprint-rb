class AddDurationToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :duration, :integer, null: false
  end
end
