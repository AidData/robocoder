class AddUnorderedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :unordered, :boolean
  end
end
