class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :code
      t.string :description
      t.datetime :starts_at
      t.datetime :expires_at
      t.integer :percent

      t.timestamps null: false
    end

    add_index :promotions, :code, unique: true
  end
end
