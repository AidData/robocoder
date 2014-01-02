class AddMarkerColorToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :marker_color, :string
  end
end
