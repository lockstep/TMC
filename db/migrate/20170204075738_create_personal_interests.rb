class CreatePersonalInterests < ActiveRecord::Migration
  def change
    create_table :personal_interests do |t|
      t.integer :user_id
      t.integer :interest_id

      t.timestamps null: false
    end
  end
end
