class CreateOrganizedBreakoutSessions < ActiveRecord::Migration
  def change
    create_table :organized_breakout_sessions do |t|
      t.integer :user_id
      t.integer :breakout_session_id

      t.timestamps null: false
    end

    add_index :organized_breakout_sessions, [:user_id, :breakout_session_id],
      name: 'organized_breakout_sessions_index'
  end
end
