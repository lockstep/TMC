class CreateBreakoutSessionLocationTimeslots < ActiveRecord::Migration
  def change
    create_table :breakout_session_location_timeslots do |t|
      t.references :breakout_session_location,  foreign_key: true,
        index: { name: 'index_location_timeslot_on_session_location_id' }
      t.time :start_time
      t.time :end_time
      t.date :day
      t.references :breakout_session, foreign_key: true,
        index: { name: 'index_location_timeslot_on_session_id' }

      t.timestamps null: false
    end
  end
end
