class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :amount
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
