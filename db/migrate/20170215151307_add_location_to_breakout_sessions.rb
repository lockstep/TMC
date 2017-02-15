class AddLocationToBreakoutSessions < ActiveRecord::Migration
  def change
    add_column :breakout_sessions, :breakout_session_location_id, :integer
  end
end
