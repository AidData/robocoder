class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :words

      t.timestamps
    end
  end
end
