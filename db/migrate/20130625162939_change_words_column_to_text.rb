class ChangeWordsColumnToText < ActiveRecord::Migration
  def up
    change_column :matches, :words, :text
  end

  def down
    change_column :matches, :words, :string
  end
end
