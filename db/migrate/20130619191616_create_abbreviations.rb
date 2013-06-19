class CreateAbbreviations < ActiveRecord::Migration
  def change
    create_table :abbreviations do |t|
      t.string :word
      t.text :abbreviations

      t.timestamps
    end
  end
end
