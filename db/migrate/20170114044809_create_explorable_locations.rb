class CreateExplorableLocations < ActiveRecord::Migration
  def change
    create_table :explorable_locations do |t|
      t.references :explorable, index: true, polymorphic: true
      t.references :visual_exploration, index: true, foreign_key: true
      t.string :label
      t.float :x
      t.float :y

      t.timestamps null: false
    end
  end
end
