class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :external_id
      t.string :codever

      t.timestamps null: false
    end

    add_index :tracks, [:external_id, :codever], unique: true
  end
end
