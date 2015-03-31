class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.integer :code, null: false
      t.integer :time, null: false
      t.integer :track_id, null: false
    end

    add_index :codes, [:code, :time, :track_id], unique: true
  end
end
