class CreateBreakoutSessions < ActiveRecord::Migration
  def change
    create_table :breakout_sessions do |t|
      t.string :name
      t.date :day
      t.time :start_time
      t.time :end_time
      t.references :conference, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
