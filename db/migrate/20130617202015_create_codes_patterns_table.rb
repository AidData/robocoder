class CreateCodesPatternsTable < ActiveRecord::Migration
  def up
    create_table :codes_patterns, id: false do |t|
      t.references :code
      t.references :pattern
    end
  end

  def down
    drop_table :codes_patterns
  end
end
