class AddKeywordAndAddressToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :keyword, :string
    add_column :positions, :address, :text
  end
end
