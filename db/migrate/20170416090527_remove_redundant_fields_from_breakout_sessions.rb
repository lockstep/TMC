class RemoveRedundantFieldsFromBreakoutSessions < ActiveRecord::Migration
  def change
    remove_column :breakout_sessions, :day, :date
    remove_column :breakout_sessions, :start_time, :time
    remove_column :breakout_sessions, :end_time, :time
  end
end
