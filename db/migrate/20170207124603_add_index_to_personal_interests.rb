class AddIndexToPersonalInterests < ActiveRecord::Migration
  def change
    add_index :personal_interests, [:user_id, :interest_id]
  end
end
