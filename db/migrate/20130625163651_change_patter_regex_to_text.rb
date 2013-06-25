class ChangePatterRegexToText < ActiveRecord::Migration
  def up
    change_column :patterns, :regex, :text
  end

  def down
    change_column :patterns, :regex, :string
  end
end
