class AddDescriptionToBreakoutSessions < ActiveRecord::Migration
  def change
    change_column_null :breakout_sessions, :name, false

    remove_column :breakout_sessions, :day, :date
    add_column :breakout_sessions, :description, :text, default: "", null: false

    remove_column :breakout_sessions, :start_time, :time
    add_column :breakout_sessions, :starts_at, :datetime

    remove_column :breakout_sessions, :end_time, :time
    add_column :breakout_sessions, :ends_at, :datetime
  end
end
