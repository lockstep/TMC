class AddCapacityToBreakoutSessionLocations < ActiveRecord::Migration
  def change
    add_column :breakout_session_locations, :capacity, :integer
  end
end
