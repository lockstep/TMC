class CreateBreakoutSessionAttendances < ActiveRecord::Migration
  def change
    create_table :breakout_session_attendances do |t|
      t.integer :user_id
      t.integer :breakout_session_id

      t.timestamps null: false
    end

    add_index :breakout_session_attendances, [:user_id, :breakout_session_id],
      name: 'breakout_session_attendances_index'
  end
end
