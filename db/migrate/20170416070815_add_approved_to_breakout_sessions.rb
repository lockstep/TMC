class AddApprovedToBreakoutSessions < ActiveRecord::Migration
  def change
    add_column :breakout_sessions, :approved, :boolean, default: false
  end
end
