class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes, {id: false} do |t|
      t.string :name
      t.integer :number

      t.timestamps
    end
  end
end
