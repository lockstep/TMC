class CreateVisualExplorations < ActiveRecord::Migration
  def change
    create_table :visual_explorations do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
