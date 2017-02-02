class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :name
      t.boolean :public, default: false

      t.timestamps null: false
    end
  end
end
