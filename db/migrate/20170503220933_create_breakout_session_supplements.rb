class CreateBreakoutSessionSupplements < ActiveRecord::Migration
  def change
    create_table :breakout_session_supplements do |t|
      t.references :breakout_session, index: true, foreign_key: true
      t.attachment :document

      t.timestamps null: false
    end
  end
end
