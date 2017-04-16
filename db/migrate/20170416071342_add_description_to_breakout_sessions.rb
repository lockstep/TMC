class AddDescriptionToBreakoutSessions < ActiveRecord::Migration
  def change
    add_column :breakout_sessions, :description, :text
  end
end
