class CreateActivities < ActiveRecord::Migration
	def change
		create_table :activities do |t|
			t.string :identifier, unique: true
			t.string :title
			t.text :description
			t.string :country

			t.timestamps
		end
	end
end
