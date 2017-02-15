class CreateBreakoutSessionAttendees < ActiveRecord::Migration
  def change
    create_table :breakout_session_attendees do |t|
      t.integer :user_id
      t.integer :breakout_session_id

      t.timestamps null: false
    end

    add_index :breakout_session_attendees, [:user_id, :breakout_session_id],
      name: 'breakout_session_attendees_index'
  end
end
