class AddPrecisionToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :precision, :string
  end
end
