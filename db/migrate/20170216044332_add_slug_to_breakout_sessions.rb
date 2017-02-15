class AddSlugToBreakoutSessions < ActiveRecord::Migration
  def change
    add_column :breakout_sessions, :slug, :string
    add_index :breakout_sessions, :slug, unique: true
  end
end
