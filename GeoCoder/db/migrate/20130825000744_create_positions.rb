class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.decimal :lat
      t.decimal :long
      t.references :activity

      t.timestamps
    end
    add_index :positions, :activity_id
  end
end
