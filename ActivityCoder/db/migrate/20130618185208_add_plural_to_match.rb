class AddPluralToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :plural, :boolean
  end
end
