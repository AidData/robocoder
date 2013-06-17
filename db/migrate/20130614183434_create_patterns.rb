class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :regex
      t.references :code

      t.timestamps
    end
  end
end
