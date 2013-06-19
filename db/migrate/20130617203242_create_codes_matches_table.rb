class CreateCodesMatchesTable < ActiveRecord::Migration
  def up
    create_table :codes_matches, id: false do |t|
      t.references :code
      t.references :match
    end
  end

  def down
    drop_table :codes_matches
  end
end
