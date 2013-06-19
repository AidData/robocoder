class AddCompleteTextToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :complete_text, :boolean
  end
end
