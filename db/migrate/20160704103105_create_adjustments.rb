class CreateAdjustments < ActiveRecord::Migration
  def change
    create_table :adjustments do |t|
      t.references :order, index: true, foreign_key: true
      t.float :amount
      t.references :promotion, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
