class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.integer :stock
      t.float :price
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
